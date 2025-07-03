import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/domain/entities/movie.dart';
import 'package:movie_app_dicoding/domain/usecases/movie_usecases.dart';
import 'package:movie_app_dicoding/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app_dicoding/presentation/pages/movie_category_page.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../cubit/movie_list_cubit_mock.mocks.dart';

void main() {
  late MockMovieRepository mockRepository;
  late MovieListCubit movieListCubit;

  final testMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'Test Overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.0,
    releaseDate: '2023-01-01',
  );

  setUp(() {
    mockRepository = MockMovieRepository();
    movieListCubit = MovieListCubit(
      getPopularMovies: GetPopularMovies(mockRepository),
      getTopRatedMovies: GetTopRatedMovies(mockRepository),
      getNowPlayingMovies: GetNowPlayingMovies(mockRepository),
      searchMovies: SearchMovies(mockRepository),
      getMovieDetail: GetMovieDetail(mockRepository),
      getMovieRecommendations: GetMovieRecommendations(mockRepository),
      getWatchlist: GetMovieWatchlist(mockRepository),
      addToWatchlistUsecase: AddMovieToWatchlist(mockRepository),
      removeFromWatchlistUsecase: RemoveMovieFromWatchlist(mockRepository),
      isAddedToWatchlistUsecase: IsMovieAddedToWatchlist(mockRepository),
    );

    when(mockRepository.getMovieDetail(1)).thenAnswer((_) async => testMovie);
    when(
      mockRepository.getMovieRecommendations(1),
    ).thenAnswer((_) async => [testMovie]);
    when(
      mockRepository.isMovieAddedToWatchlist(1),
    ).thenAnswer((_) async => false);
  });

  group('MovieCategoryPage Widget Test', () {
    testWidgets('menampilkan daftar movie kategori', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: MaterialApp(
              home: MovieCategoryPage(
                title: 'Popular Movies',
                movies: [testMovie],
              ),
            ),
          ),
        );

        expect(find.text('Popular Movies'), findsOneWidget);
        expect(find.text('Test Movie'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testWidgets('menampilkan pesan kosong saat tidak ada movie', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: movieListCubit,
          child: MaterialApp(
            home: MovieCategoryPage(title: 'Popular Movies', movies: []),
          ),
        ),
      );

      expect(find.text('No movies found'), findsOneWidget);
    });

    testWidgets('menampilkan icon saat tidak ada poster', (
      WidgetTester tester,
    ) async {
      final movieWithoutPoster = Movie(
        id: 1,
        title: 'No Poster Movie',
        overview: 'Test Overview',
        posterPath: '',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.0,
        releaseDate: '2023-01-01',
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: movieListCubit,
          child: MaterialApp(
            home: MovieCategoryPage(
              title: 'Popular Movies',
              movies: [movieWithoutPoster],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.movie), findsOneWidget);
      expect(find.text('No Poster Movie'), findsOneWidget);
    });

    testWidgets('tap pada movie membuka halaman detail', (
      WidgetTester tester,
    ) async {
      bool navigatedToDetail = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: MaterialApp(
              home: MovieCategoryPage(
                title: 'Popular Movies',
                movies: [testMovie],
              ),
              routes: {
                '/movie_detail': (context) {
                  navigatedToDetail = true;
                  return const Scaffold();
                },
              },
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        expect(navigatedToDetail, isTrue);
      });
    });
  });
}
