import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/movie_usecases.dart';
import '../../domain/entities/movie.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetNowPlayingMovies getNowPlayingMovies;
  final SearchMovies searchMovies;
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetMovieWatchlist getWatchlist;
  final AddMovieToWatchlist addToWatchlistUsecase;
  final RemoveMovieFromWatchlist removeFromWatchlistUsecase;
  final IsMovieAddedToWatchlist isAddedToWatchlistUsecase;

  MovieListCubit({
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getNowPlayingMovies,
    required this.searchMovies,
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchlist,
    required this.addToWatchlistUsecase,
    required this.removeFromWatchlistUsecase,
    required this.isAddedToWatchlistUsecase,
  }) : super(MovieListInitial());

  Future<void> fetchAll() async {
    emit(MovieListLoading());
    try {
      final popular = await getPopularMovies();
      final topRated = await getTopRatedMovies();
      final nowPlaying = await getNowPlayingMovies();
      final watchlist = await getWatchlist();
      emit(
        MovieListLoaded(
          popular: popular,
          topRated: topRated,
          nowPlaying: nowPlaying,
          watchlist: watchlist,
        ),
      );
    } catch (e) {
      emit(MovieListError(e.toString()));
    }
  }

  Future<void> fetchAndEmitWatchlist() async {
    final watchlist = await getWatchlist();
    final currentState = state;
    if (currentState is MovieListLoaded) {
      emit(
        MovieListLoaded(
          popular: currentState.popular,
          topRated: currentState.topRated,
          nowPlaying: currentState.nowPlaying,
          watchlist: watchlist,
        ),
      );
    } else {
      emit(MovieWatchlistLoaded(watchlist));
    }
  }

  Future<void> addToWatchlist(int movieId) async {
    await addToWatchlistUsecase(movieId);
    await fetchAndEmitWatchlist();
  }

  Future<void> removeFromWatchlist(int movieId) async {
    await removeFromWatchlistUsecase(movieId);
    await fetchAndEmitWatchlist();
  }

  Future<List<Movie>> fetchWatchlistList() async {
    final watchlist = await getWatchlist();
    return watchlist;
  }

  Future<Movie> fetchDetail(int id) async {
    return await getMovieDetail(id);
  }

  Future<List<Movie>> fetchRecommendations(int id) async {
    return await getMovieRecommendations(id);
  }

  Future<bool> isAddedToWatchlist(int movieId) async {
    return await isAddedToWatchlistUsecase(movieId);
  }
}
