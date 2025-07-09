import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/domain/entities/movie.dart';
import 'package:movie_app_dicoding/domain/usecases/movie_usecases.dart';
import 'package:movie_app_dicoding/presentation/cubit/movie_list_cubit.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_cubit_mock.mocks.dart';

class DummyMovie extends Movie {
  DummyMovie({
    super.id = 1,
    super.title = 'Test Movie',
    super.overview = 'Overview',
    super.posterPath = '/test.jpg',
    super.backdropPath = '/backdrop.jpg',
    super.voteAverage = 8.0,
    super.releaseDate = '2022-01-01',
  });
}

void main() {
  late MovieListCubit cubit;
  late MockMovieRepository mockRepository;
  late GetPopularMovies getPopularMovies;
  late GetTopRatedMovies getTopRatedMovies;
  late GetNowPlayingMovies getNowPlayingMovies;
  late SearchMovies searchMovies;
  late GetMovieDetail getMovieDetail;
  late GetMovieRecommendations getMovieRecommendations;
  late GetMovieWatchlist getMovieWatchlist;
  late AddMovieToWatchlist addMovieToWatchlist;
  late RemoveMovieFromWatchlist removeMovieFromWatchlist;
  late IsMovieAddedToWatchlist isAddedToWatchlist;

  final tMovie = DummyMovie();
  final tList = [tMovie];

  setUp(() {
    mockRepository = MockMovieRepository();
    getPopularMovies = GetPopularMovies(mockRepository);
    getTopRatedMovies = GetTopRatedMovies(mockRepository);
    getNowPlayingMovies = GetNowPlayingMovies(mockRepository);
    searchMovies = SearchMovies(mockRepository);
    getMovieDetail = GetMovieDetail(mockRepository);
    getMovieRecommendations = GetMovieRecommendations(mockRepository);
    getMovieWatchlist = GetMovieWatchlist(mockRepository);
    addMovieToWatchlist = AddMovieToWatchlist(mockRepository);
    removeMovieFromWatchlist = RemoveMovieFromWatchlist(mockRepository);
    isAddedToWatchlist = IsMovieAddedToWatchlist(mockRepository);

    cubit = MovieListCubit(
      getPopularMovies: getPopularMovies,
      getTopRatedMovies: getTopRatedMovies,
      getNowPlayingMovies: getNowPlayingMovies,
      searchMovies: searchMovies,
      getMovieDetail: getMovieDetail,
      getMovieRecommendations: getMovieRecommendations,
      getWatchlist: getMovieWatchlist,
      addToWatchlistUsecase: addMovieToWatchlist,
      removeFromWatchlistUsecase: removeMovieFromWatchlist,
      isAddedToWatchlistUsecase: isAddedToWatchlist,
    );
  });

  blocTest<MovieListCubit, MovieListState>(
    'emits [Loading, Loaded] when fetchAll is called',
    build: () {
      when(mockRepository.getPopularMovies()).thenAnswer((_) async => tList);
      when(mockRepository.getTopRatedMovies()).thenAnswer((_) async => tList);
      when(mockRepository.getNowPlayingMovies()).thenAnswer((_) async => tList);
      when(mockRepository.getMovieWatchlist()).thenAnswer((_) async => tList);
      return cubit;
    },
    act: (cubit) => cubit.fetchAll(),
    expect: () => [isA<MovieListLoading>(), isA<MovieListLoaded>()],
  );

  blocTest<MovieListCubit, MovieListState>(
    'emits [Loading, Error] when fetchAll fails',
    build: () {
      when(mockRepository.getPopularMovies()).thenThrow(Exception('error'));
      when(mockRepository.getTopRatedMovies()).thenAnswer((_) async => tList);
      when(mockRepository.getNowPlayingMovies()).thenAnswer((_) async => tList);
      return cubit;
    },
    act: (cubit) => cubit.fetchAll(),
    expect: () => [isA<MovieListLoading>(), isA<MovieListError>()],
  );

  test('fetchDetail returns correct movie', () async {
    when(mockRepository.getMovieDetail(1)).thenAnswer((_) async => tMovie);
    final result = await cubit.fetchDetail(1);
    expect(result, tMovie);
  });

  test('fetchRecommendations returns correct list', () async {
    when(
      mockRepository.getMovieRecommendations(1),
    ).thenAnswer((_) async => tList);
    final result = await cubit.fetchRecommendations(1);
    expect(result, tList);
  });

  test('fetchWatchlistList returns correct list', () async {
    when(mockRepository.getMovieWatchlist()).thenAnswer((_) async => tList);
    final result = await cubit.fetchWatchlistList();
    expect(result, tList);
  });

  test('addToWatchlist and removeFromWatchlist call repository', () async {
    await cubit.addToWatchlistUsecase(1);
    await cubit.removeFromWatchlistUsecase(1);
    verify(mockRepository.addMovieToWatchlist(1)).called(1);
    verify(mockRepository.removeMovieFromWatchlist(1)).called(1);
  });

  test('isAddedToWatchlist returns correct value', () async {
    when(
      mockRepository.isMovieAddedToWatchlist(1),
    ).thenAnswer((_) async => true);
    final result = await cubit.isAddedToWatchlist(1);
    expect(result, true);
  });

  test('fetchDetail throws error if repository throws', () async {
    when(mockRepository.getMovieDetail(999)).thenThrow(Exception('not found'));
    expect(() => cubit.fetchDetail(999), throwsA(isA<Exception>()));
  });
}
