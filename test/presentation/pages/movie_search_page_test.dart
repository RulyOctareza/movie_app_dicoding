import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/domain/entities/movie.dart';
import 'package:movie_app_dicoding/domain/usecases/movie_usecases.dart';
import 'package:movie_app_dicoding/presentation/cubit/movie_list_cubit.dart';
import 'package:movie_app_dicoding/presentation/pages/movie_search_page.dart';
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
  });

  group('MovieSearchPage Widget Test', () {
    testWidgets('menampilkan loading saat search', (WidgetTester tester) async {
      when(mockRepository.searchMovies('test')).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        return [testMovie];
      });
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: const MaterialApp(
              home: MovieSearchPage(),
            ),
          ),
        );
        await tester.enterText(find.byType(TextField), 'test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump(); // start async
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 400)); // finish async
      });
    });

    testWidgets('menampilkan hasil pencarian', (WidgetTester tester) async {
      when(mockRepository.searchMovies('test')).thenAnswer((_) async => [testMovie]);
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: const MaterialApp(
              home: MovieSearchPage(),
            ),
          ),
        );
        await tester.enterText(find.byType(TextField), 'test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        expect(find.text('Test Movie'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testWidgets('menampilkan error saat search gagal', (WidgetTester tester) async {
      when(mockRepository.searchMovies('error')).thenThrow(Exception('Failed'));
      await tester.pumpWidget(
        BlocProvider.value(
          value: movieListCubit,
          child: const MaterialApp(
            home: MovieSearchPage(),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'error');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.textContaining('Failed'), findsOneWidget);
    });

    testWidgets('clear button menghapus hasil pencarian', (WidgetTester tester) async {
      when(mockRepository.searchMovies('test')).thenAnswer((_) async => [testMovie]);
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: const MaterialApp(
              home: MovieSearchPage(),
            ),
          ),
        );
        await tester.enterText(find.byType(TextField), 'test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        expect(find.text('Test Movie'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.close));
        await tester.pump();
        expect(find.text('Test Movie'), findsNothing);
      });
    });

    testWidgets('tap pada movie navigasi ke detail', (WidgetTester tester) async {
      when(mockRepository.searchMovies('test')).thenAnswer((_) async => [testMovie]);
      when(mockRepository.getMovieDetail(1)).thenAnswer((_) async => testMovie);
      when(mockRepository.getMovieRecommendations(1)).thenAnswer((_) async => [testMovie]);
      bool navigated = false;
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: movieListCubit,
            child: MaterialApp(
              home: const MovieSearchPage(),
              onGenerateRoute: (settings) {
                if (settings.name == '/movie_detail') {
                  navigated = true;
                  return MaterialPageRoute(builder: (_) => const Scaffold());
                }
                return null;
              },
            ),
          ),
        );
        await tester.enterText(find.byType(TextField), 'test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();
        expect(navigated, isTrue);
      });
    });
  });
}
