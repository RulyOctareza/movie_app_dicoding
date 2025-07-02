import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:movie_app_dicoding/presentation/pages/tv_series_home_page.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_cubit.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_state.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series.dart';
import 'tv_series_home_page_mock.mocks.dart';

void main() {
  group('TvSeriesHomePage Interaksi UI', () {
    late MockTvSeriesListCubit mockCubit;
    setUp(() {
      mockCubit = MockTvSeriesListCubit();
    });

    testWidgets('tap See More navigasi ke halaman kategori', (WidgetTester tester) async {
      final tvList = [
        TvSeries(id: 1, name: 'Test TV', overview: 'desc', posterPath: '/test.jpg', voteAverage: 8.0),
      ];
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: tvList, topRated: tvList, nowPlaying: tvList));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            routes: {
              '/category': (context) => const Scaffold(body: Text('Kategori Page')),
            },
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: const TvSeriesHomePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final seeMore = find.text('See More').first;
        await tester.tap(seeMore);
        await tester.pumpAndSettle();
        expect(find.text('Kategori Page'), findsOneWidget);
      });
    });

    testWidgets('tap item TV navigasi ke detail', (WidgetTester tester) async {
      final tvList = [
        TvSeries(id: 1, name: 'Test TV', overview: 'desc', posterPath: '/test.jpg', voteAverage: 8.0),
      ];
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: tvList, topRated: tvList, nowPlaying: tvList));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(mockCubit.getDetail(any)).thenAnswer((_) async => tvList[0]);
      when(mockCubit.getRecommendations(any)).thenAnswer((_) async => tvList);
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            routes: {
              '/detail': (context) => const Scaffold(body: Text('Detail Page')),
            },
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: const TvSeriesHomePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final tvItem = find.text('Test TV').first;
        await tester.tap(tvItem);
        await tester.pumpAndSettle();
        expect(find.text('Detail Page'), findsOneWidget);
      });
    });

    testWidgets('tap search navigasi ke halaman search', (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: [], topRated: [], nowPlaying: []));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            routes: {
              '/search': (context) => const Scaffold(body: Text('Search Page')),
            },
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: const TvSeriesHomePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final searchBtn = find.byIcon(Icons.search);
        await tester.tap(searchBtn);
        await tester.pumpAndSettle();
        expect(find.text('Search Page'), findsOneWidget);
      });
    });
  });
}
