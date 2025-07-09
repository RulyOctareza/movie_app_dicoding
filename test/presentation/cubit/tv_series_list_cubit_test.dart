import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_cubit.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series_detail.dart';
import 'package:movie_app_dicoding/domain/entities/season.dart';
import 'package:movie_app_dicoding/domain/usecases/tv_series_usecases.dart';
import 'package:movie_app_dicoding/domain/usecases/get_season_episodes.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_state.dart'
    as tv_state;

import '../../domain/usecases/tv_series_repository_mock.mocks.dart';

void main() {
  late TvSeriesListCubit cubit;
  late MockTvSeriesRepository mockRepo;
  late GetPopularTvSeries getPopular;
  late GetTopRatedTvSeries getTopRated;
  late GetNowPlayingTvSeries getNowPlaying;
  late SearchTvSeries search;
  late GetTvSeriesDetail getDetail;
  late GetTvSeriesRecommendations getRecs;
  late GetWatchlist getWatchlist;
  late AddToWatchlist addToWatchlist;
  late RemoveFromWatchlist removeFromWatchlist;
  late IsAddedToWatchlist isAddedToWatchlist;
  late GetSeasonEpisodes getSeasonEpisodes;

  setUp(() {
    mockRepo = MockTvSeriesRepository();
    getPopular = GetPopularTvSeries(mockRepo);
    getTopRated = GetTopRatedTvSeries(mockRepo);
    getNowPlaying = GetNowPlayingTvSeries(mockRepo);
    search = SearchTvSeries(mockRepo);
    getDetail = GetTvSeriesDetail(mockRepo);
    getRecs = GetTvSeriesRecommendations(mockRepo);
    getWatchlist = GetWatchlist(mockRepo);
    addToWatchlist = AddToWatchlist(mockRepo);
    removeFromWatchlist = RemoveFromWatchlist(mockRepo);
    isAddedToWatchlist = IsAddedToWatchlist(mockRepo);
    getSeasonEpisodes = GetSeasonEpisodes(mockRepo);
    cubit = TvSeriesListCubit(
      getPopularTvSeries: getPopular,
      getTopRatedTvSeries: getTopRated,
      getNowPlayingTvSeries: getNowPlaying,
      searchTvSeries: search,
      getTvSeriesDetail: getDetail,
      getTvSeriesRecommendations: getRecs,
      getWatchlist: getWatchlist,
      addToWatchlistUsecase: addToWatchlist,
      removeFromWatchlistUsecase: removeFromWatchlist,
      isAddedToWatchlistUsecase: isAddedToWatchlist,
      getSeasonEpisodesUsecase: getSeasonEpisodes,
    );
  });

  final tTvSeries = TvSeries(
    id: 1,
    name: 'Test Series',
    overview: 'Overview',
    posterPath: '/test.jpg',
    voteAverage: 8.0,
  );
  final tList = [tTvSeries];

  blocTest<TvSeriesListCubit, tv_state.TvSeriesListState>(
    'emits [Loading, Loaded] when fetchAll is called',
    build: () {
      when(mockRepo.getPopularTvSeries()).thenAnswer((_) async => tList);
      when(mockRepo.getTopRatedTvSeries()).thenAnswer((_) async => tList);
      when(mockRepo.getNowPlayingTvSeries()).thenAnswer((_) async => tList);
      when(mockRepo.getWatchlist()).thenAnswer((_) async => []);
      return cubit;
    },
    act: (cubit) => cubit.fetchAll(),
    expect: () => [
      isA<tv_state.TvSeriesListLoading>(),
      isA<tv_state.TvSeriesListLoaded>(),
    ],
  );

  blocTest<TvSeriesListCubit, tv_state.TvSeriesListState>(
    'emits [Loading, Error] when fetchAll fails',
    build: () {
      when(mockRepo.getPopularTvSeries()).thenThrow(Exception('error'));
      when(mockRepo.getTopRatedTvSeries()).thenAnswer((_) async => tList);
      when(mockRepo.getNowPlayingTvSeries()).thenAnswer((_) async => tList);
      when(mockRepo.getWatchlist()).thenAnswer((_) async => []);
      return cubit;
    },
    act: (cubit) => cubit.fetchAll(),
    expect: () => [
      isA<tv_state.TvSeriesListLoading>(),
      isA<tv_state.TvSeriesListError>(),
    ],
  );

  blocTest<TvSeriesListCubit, tv_state.TvSeriesListState>(
    'emits [Loading, Loaded] when fetchAll returns empty lists',
    build: () {
      when(mockRepo.getPopularTvSeries()).thenAnswer((_) async => []);
      when(mockRepo.getTopRatedTvSeries()).thenAnswer((_) async => []);
      when(mockRepo.getNowPlayingTvSeries()).thenAnswer((_) async => []);
      when(mockRepo.getWatchlist()).thenAnswer((_) async => []);
      return cubit;
    },
    act: (cubit) => cubit.fetchAll(),
    expect: () => [
      isA<tv_state.TvSeriesListLoading>(),
      isA<tv_state.TvSeriesListLoaded>(),
    ],
    verify: (cubit) {
      verify(mockRepo.getPopularTvSeries()).called(1);
      verify(mockRepo.getTopRatedTvSeries()).called(1);
      verify(mockRepo.getNowPlayingTvSeries()).called(1);
    },
  );

  test('search returns list from repository', () async {
    when(mockRepo.searchTvSeries('query')).thenAnswer((_) async => tList);
    final result = await cubit.search('query');
    expect(result, tList);
  });

  test('getDetail returns detail from repository', () async {
    final detail = TvSeriesDetail(
      id: 1,
      name: 'Test Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      seasons: [
        Season(
          id: 1,
          name: 'Season 1',
          seasonNumber: 1,
          episodeCount: 10,
          overview: 'desc',
          posterPath: '/season1.jpg',
        ),
      ],
    );
    when(mockRepo.getTvSeriesDetail(1)).thenAnswer((_) async => detail);
    final result = await cubit.getDetail(1);
    expect(result, detail);
  });

  test('getRecommendations returns list from repository', () async {
    when(mockRepo.getTvSeriesRecommendations(1)).thenAnswer((_) async => tList);
    final result = await cubit.getRecommendations(1);
    expect(result, tList);
  });

  test('getWatchlistList returns list from repository', () async {
    when(mockRepo.getWatchlist()).thenAnswer((_) async => tList);
    final result = await cubit.getWatchlistList();
    expect(result, tList);
  });

  test('addToWatchlist calls repository', () async {
    final detail = TvSeriesDetail(
      id: 1,
      name: 'Test Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      seasons: [],
    );
    when(mockRepo.addToWatchlist(detail)).thenAnswer((_) async {});
    when(mockRepo.getWatchlist()).thenAnswer((_) async => []);
    await cubit.addToWatchlist(detail);
    verify(mockRepo.addToWatchlist(detail)).called(1);
  });

  test('removeFromWatchlist calls repository', () async {
    when(mockRepo.removeFromWatchlist(1)).thenAnswer((_) async {});
    when(mockRepo.getWatchlist()).thenAnswer((_) async => []);
    await cubit.removeFromWatchlist(1);
    verify(mockRepo.removeFromWatchlist(1)).called(1);
  });

  test('isAddedToWatchlist returns bool from repository', () async {
    when(mockRepo.isAddedToWatchlist(1)).thenAnswer((_) async => true);
    final result = await cubit.isAddedToWatchlist(1);
    expect(result, true);
  });

  test('getSeasonEpisodes returns list from repository', () async {
    when(mockRepo.getSeasonEpisodes(1, 1)).thenAnswer((_) async => []);
    final result = await cubit.getSeasonEpisodes(1, 1);
    expect(result, []);
  });

  test('search throws error from repository', () async {
    when(mockRepo.searchTvSeries('error')).thenThrow(Exception('search error'));
    expect(() => cubit.search('error'), throwsA(isA<Exception>()));
  });

  test('getDetail throws error from repository', () async {
    when(mockRepo.getTvSeriesDetail(999)).thenThrow(Exception('not found'));
    expect(() => cubit.getDetail(999), throwsA(isA<Exception>()));
  });

  test('getRecommendations throws error from repository', () async {
    when(
      mockRepo.getTvSeriesRecommendations(999),
    ).thenThrow(Exception('not found'));
    expect(() => cubit.getRecommendations(999), throwsA(isA<Exception>()));
  });

  test('getWatchlistList throws error from repository', () async {
    when(mockRepo.getWatchlist()).thenThrow(Exception('db error'));
    expect(() => cubit.getWatchlistList(), throwsA(isA<Exception>()));
  });

  test('addToWatchlist throws error from repository', () async {
    final detail = TvSeriesDetail(
      id: 1,
      name: 'Test Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
      seasons: [],
    );
    when(mockRepo.addToWatchlist(detail)).thenThrow(Exception('add error'));
    expect(() => cubit.addToWatchlist(detail), throwsA(isA<Exception>()));
  });

  test('removeFromWatchlist throws error from repository', () async {
    when(mockRepo.removeFromWatchlist(1)).thenThrow(Exception('remove error'));
    expect(() => cubit.removeFromWatchlist(1), throwsA(isA<Exception>()));
  });

  test('isAddedToWatchlist throws error from repository', () async {
    when(mockRepo.isAddedToWatchlist(1)).thenThrow(Exception('check error'));
    expect(() => cubit.isAddedToWatchlist(1), throwsA(isA<Exception>()));
  });

  test('getSeasonEpisodes throws error from repository', () async {
    when(mockRepo.getSeasonEpisodes(1, 1)).thenThrow(Exception('season error'));
    expect(() => cubit.getSeasonEpisodes(1, 1), throwsA(isA<Exception>()));
  });
}
