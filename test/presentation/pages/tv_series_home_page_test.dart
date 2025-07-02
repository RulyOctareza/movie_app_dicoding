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
  group('TvSeriesHomePage Widget Test', () {
    late MockTvSeriesListCubit mockCubit;
    setUp(() {
      mockCubit = MockTvSeriesListCubit();
    });

    testWidgets('menampilkan loading saat state loading', (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(TvSeriesListLoading());
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: const TvSeriesHomePage(),
            ),
          ),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    testWidgets('menampilkan daftar kategori saat state loaded', (WidgetTester tester) async {
      final tvList = [
        TvSeries(id: 1, name: 'Test TV', overview: 'desc', posterPath: '/test.jpg', voteAverage: 8.0),
      ];
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: tvList, topRated: tvList, nowPlaying: tvList));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: const TvSeriesHomePage(),
            ),
          ),
        );
        expect(find.text('Now Playing'), findsOneWidget);
        expect(find.text('Popular'), findsOneWidget);
        expect(find.text('Top Rated'), findsOneWidget);
        expect(find.text('Test TV'), findsWidgets);
        expect(find.text('See More'), findsNWidgets(3));
      });
    });

    testWidgets('menampilkan error message saat state error', (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(TvSeriesListError('Error!'));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: const TvSeriesHomePage(),
            ),
          ),
        );
        expect(find.text('Error!'), findsOneWidget);
      });
    });
  });
}
