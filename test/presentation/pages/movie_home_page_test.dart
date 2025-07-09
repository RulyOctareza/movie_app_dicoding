import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/domain/entities/movie.dart';
import 'package:movie_app_dicoding/domain/usecases/movie_usecases.dart';
import 'package:movie_app_dicoding/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app_dicoding/presentation/pages/movie_home_page.dart';
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

  final movies = [testMovie];

  Future<void> setUpNavigationTest(WidgetTester tester) async {
    movieListCubit.emit(
      MovieListLoaded(
        popular: movies,
        topRated: movies,
        nowPlaying: movies,
        watchlist: const [],
      ),
    );

    await tester.pumpWidget(
      BlocProvider.value(
        value: movieListCubit,
        child: MaterialApp(
          home: const MovieHomePage(),
          routes: {
            '/movie_detail': (context) => const Scaffold(),
            '/movie_category': (context) => const Scaffold(),
          },
        ),
      ),
    );
    await tester.pump();
  }

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

    // Default repository responses
    when(mockRepository.getPopularMovies()).thenAnswer((_) async => movies);
    when(mockRepository.getTopRatedMovies()).thenAnswer((_) async => movies);
    when(mockRepository.getNowPlayingMovies()).thenAnswer((_) async => movies);
    when(mockRepository.getMovieDetail(1)).thenAnswer((_) async => testMovie);
    when(
      mockRepository.getMovieRecommendations(1),
    ).thenAnswer((_) async => movies);
  });

  group('MovieHomePage Widget Test', () {
    testWidgets('menampilkan loading saat state loading', (
      WidgetTester tester,
    ) async {
      // Force loading state
      movieListCubit.emit(MovieListLoading());

      await tester.pumpWidget(
        BlocProvider.value(
          value: movieListCubit,
          child: const MaterialApp(home: MovieHomePage()),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('menampilkan daftar kategori saat state loaded', (
      WidgetTester tester,
    ) async {
      // Emit loaded state with test data
      movieListCubit.emit(
        MovieListLoaded(
          popular: movies,
          topRated: movies,
          nowPlaying: movies,
          watchlist: const [],
        ),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: const MaterialApp(home: MovieHomePage()),
          ),
        );

        await tester.pump();

        expect(find.text('Popular'), findsOneWidget);
        expect(find.text('Top Rated'), findsOneWidget);
        expect(find.text('Now Playing'), findsOneWidget);
        expect(find.text('See More'), findsNWidgets(3));
        expect(
          find.byType(ListView),
          findsNWidgets(4),
        ); // 1 outer + 3 movie lists
      });
    });

    testWidgets('menampilkan error message saat state error', (
      WidgetTester tester,
    ) async {
      // Emit error state directly
      movieListCubit.emit(MovieListError('Failed to load movies'));

      await tester.pumpWidget(
        BlocProvider.value(
          value: movieListCubit,
          child: const MaterialApp(home: MovieHomePage()),
        ),
      );

      await tester.pump();

      expect(find.text('Failed to load movies'), findsOneWidget);
    });

    testWidgets('tap See More membuka halaman kategori', (
      WidgetTester tester,
    ) async {
      String? navigatedRoute;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: MaterialApp(
              home: const MovieHomePage(),
              onGenerateRoute: (settings) {
                navigatedRoute = settings.name;
                return MaterialPageRoute(
                  builder: (context) => const Scaffold(),
                  settings: settings,
                );
              },
            ),
          ),
        );

        movieListCubit.emit(
          MovieListLoaded(
            popular: movies,
            topRated: movies,
            nowPlaying: movies,
            watchlist: const [],
          ),
        );

        await tester.pump();

        await tester.tap(find.text('See More').first);
        await tester.pumpAndSettle();

        expect(navigatedRoute, equals('/movie_category'));
      });
    });

    testWidgets('refresh button memanggil fetchAll', (
      WidgetTester tester,
    ) async {
      movieListCubit.emit(
        MovieListLoaded(
          popular: movies,
          topRated: movies,
          nowPlaying: movies,
          watchlist: const [],
        ),
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: movieListCubit,
          child: const MaterialApp(home: MovieHomePage()),
        ),
      );

      await tester.pump();
      clearInteractions(mockRepository);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      verify(mockRepository.getPopularMovies()).called(1);
      verify(mockRepository.getTopRatedMovies()).called(1);
      verify(mockRepository.getNowPlayingMovies()).called(1);
    });
  });
}
