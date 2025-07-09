import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';
import '../../domain/usecases/tv_series_usecases.dart';
import '../../domain/entities/episode.dart';
import '../../domain/usecases/get_season_episodes.dart';
import 'tv_series_list_state.dart';

class TvSeriesListCubit extends Cubit<TvSeriesListState> {
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final SearchTvSeries searchTvSeries;
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlist getWatchlist;
  final AddToWatchlist addToWatchlistUsecase;
  final RemoveFromWatchlist removeFromWatchlistUsecase;
  final IsAddedToWatchlist isAddedToWatchlistUsecase;
  final GetSeasonEpisodes getSeasonEpisodesUsecase;

  TvSeriesListCubit({
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
    required this.getNowPlayingTvSeries,
    required this.searchTvSeries,
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlist,
    required this.addToWatchlistUsecase,
    required this.removeFromWatchlistUsecase,
    required this.isAddedToWatchlistUsecase,
    required this.getSeasonEpisodesUsecase,
  }) : super(TvSeriesListInitial());

  Future<void> fetchAll() async {
    emit(TvSeriesListLoading());
    try {
      final popular = await getPopularTvSeries();
      final topRated = await getTopRatedTvSeries();
      final nowPlaying = await getNowPlayingTvSeries();
      final watchlist = await getWatchlist();
      emit(
        TvSeriesListLoaded(
          popular: popular,
          topRated: topRated,
          nowPlaying: nowPlaying,
          watchlist: watchlist,
        ),
      );
    } catch (e) {
      emit(TvSeriesListError(e.toString()));
    }
  }

  Future<void> fetchAndEmitWatchlist() async {
    final watchlist = await getWatchlist();
    final currentState = state;
    if (currentState is TvSeriesListLoaded) {
      emit(
        TvSeriesListLoaded(
          popular: currentState.popular,
          topRated: currentState.topRated,
          nowPlaying: currentState.nowPlaying,
          watchlist: watchlist,
        ),
      );
    } else {
      emit(TvSeriesWatchlistLoaded(watchlist));
    }
  }

  Future<List<TvSeries>> search(String query) async {
    return await searchTvSeries(query);
  }

  Future getDetail(int id) async {
    return await getTvSeriesDetail(id);
  }

  Future getRecommendations(int id) async {
    return await getTvSeriesRecommendations(id);
  }

  Future<void> addToWatchlist(TvSeriesDetail detail) async {
    await addToWatchlistUsecase(detail);
    await fetchAndEmitWatchlist();
  }

  Future<void> removeFromWatchlist(int id) async {
    await removeFromWatchlistUsecase(id);
    await fetchAndEmitWatchlist();
  }

  Future<List<TvSeries>> getWatchlistList() async {
    final watchlist = await getWatchlist();
    return watchlist;
  }

  Future<bool> isAddedToWatchlist(int id) async {
    return await isAddedToWatchlistUsecase(id);
  }

  Future<List<Episode>> getSeasonEpisodes(int tvId, int seasonNumber) async {
    return await getSeasonEpisodesUsecase(tvId, seasonNumber);
  }
}
