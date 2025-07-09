import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/domain/entities/movie.dart';
import 'package:movie_app_dicoding/domain/usecases/movie_usecases.dart';
import 'package:movie_app_dicoding/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app_dicoding/presentation/pages/movie_detail_page.dart';
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

  final testRecommendation = Movie(
    id: 2,
    title: 'Recommended Movie',
    overview: 'Recommended Overview',
    posterPath: '/rec.jpg',
    backdropPath: '/recback.jpg',
    voteAverage: 7.5,
    releaseDate: '2023-01-02',
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

    when(
      mockRepository.isMovieAddedToWatchlist(1),
    ).thenAnswer((_) async => false);
  });

  group('MovieDetailPage Widget Test', () {
    testWidgets('menampilkan detail movie dengan benar', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: MaterialApp(
              home: MovieDetailPage(
                detail: testMovie,
                recommendations: [testRecommendation],
              ),
            ),
          ),
        );

        expect(find.text('Test Movie'), findsNWidgets(2));
        expect(find.text('Test Overview'), findsOneWidget);
        expect(find.byType(Image), findsWidgets);
      });
    });

    testWidgets('menampilkan icon jika tidak ada poster', (
      WidgetTester tester,
    ) async {
      final movieWithoutPoster = Movie(
        id: 1,
        title: 'No Poster Movie',
        overview: 'Test Overview',
        posterPath: '',
        backdropPath: '',
        voteAverage: 8.0,
        releaseDate: '2023-01-01',
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: movieListCubit,
          child: MaterialApp(
            home: MovieDetailPage(
              detail: movieWithoutPoster,
              recommendations: [],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.movie), findsWidgets);
      expect(find.text('No Poster Movie'), findsNWidgets(2));
    });

    // testWidgets('bisa menambah dan menghapus dari watchlist', (
    //   WidgetTester tester,
    // ) async {
    //   // Set up watchlist mocks
    //   when(
    //     mockRepository.isMovieAddedToWatchlist(1),
    //   ).thenAnswer((_) async => false);
    //   when(mockRepository.addMovieToWatchlist(1)).thenAnswer((_) async {});
    //   when(mockRepository.removeMovieFromWatchlist(1)).thenAnswer((_) async {});
    //   // Start with empty watchlist
    //   when(mockRepository.getMovieWatchlist()).thenAnswer((_) async => []);

    //   await mockNetworkImagesFor(() async {
    //     await tester.pumpWidget(
    //       BlocProvider.value(
    //         value: movieListCubit,
    //         child: MaterialApp(
    //           home: MovieDetailPage(detail: testMovie, recommendations: []),
    //         ),
    //       ),
    //     );

    //     await tester.pump();

    //     // Add to watchlist
    //     await tester.tap(find.byIcon(Icons.bookmark_add));
    //     // After add, update mock to return the movie in watchlist
    //     when(mockRepository.getMovieWatchlist()).thenAnswer((_) async => [testMovie]);
    //     await tester.pump();
    //     // Wait for the filled bookmark icon to appear (max 2s)
    //     bool found = false;
    //     for (int i = 0; i < 20; i++) {
    //       await tester.pump(const Duration(milliseconds: 100));
    //       if (find.byIcon(Icons.bookmark).evaluate().isNotEmpty) {
    //         found = true;
    //         break;
    //       }
    //     }
    //     expect(found, isTrue, reason: 'Filled bookmark icon should appear after adding to watchlist');
    //     verify(mockRepository.addMovieToWatchlist(1)).called(1);

    //     // Remove from watchlist
    //     await tester.tap(find.byIcon(Icons.bookmark));
    //     // After remove, update mock to return empty watchlist
    //     when(mockRepository.getMovieWatchlist()).thenAnswer((_) async => []);
    //     await tester.pump();
    //     // Wait for the add bookmark icon to appear (max 2s)
    //     found = false;
    //     for (int i = 0; i < 20; i++) {
    //       await tester.pump(const Duration(milliseconds: 100));
    //       if (find.byIcon(Icons.bookmark_add).evaluate().isNotEmpty) {
    //         found = true;
    //         break;
    //       }
    //     }
    //     expect(found, isTrue, reason: 'Add bookmark icon should appear after removing from watchlist');
    //     verify(mockRepository.removeMovieFromWatchlist(1)).called(1);
    //   });
    // });

    testWidgets('menampilkan rekomendasi movies', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: MaterialApp(
              home: MovieDetailPage(
                detail: testMovie,
                recommendations: [testRecommendation, testRecommendation],
              ),
            ),
          ),
        );

        expect(find.text('Recommendations'), findsOneWidget);
        expect(find.text('Recommended Movie'), findsNWidgets(2));
      });
    });

    testWidgets('menampilkan pesan jika tidak ada rekomendasi', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: MaterialApp(
              home: MovieDetailPage(detail: testMovie, recommendations: []),
            ),
          ),
        );

        expect(find.text('No recommendations found'), findsOneWidget);
      });
    });
  });
}
