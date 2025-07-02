import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/presentation/pages/tv_series_detail_page.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series_detail.dart';
import 'package:movie_app_dicoding/domain/entities/season.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_cubit.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_state.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'tv_series_detail_page_mock.mocks.dart';

void main() {
  testWidgets('TvSeriesDetailPage renders with correct data', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      final detail = TvSeriesDetail(
        id: 1,
        name: 'Test Series',
        overview: 'Overview',
        posterPath: '/test.jpg',
        voteAverage: 8.5,
        seasons: [
          Season(
            id: 1,
            name: 'Season 1',
            seasonNumber: 1,
            episodeCount: 10,
            overview: 'Season 1 overview',
            posterPath: '/season1.jpg',
          ),
        ],
      );
      final recommendations = [
        TvSeries(
          id: 2,
          name: 'Recommended Series',
          overview: 'Recommended overview',
          posterPath: '/rec.jpg',
          voteAverage: 7.5,
        ),
      ];
      final mockCubit = MockTvSeriesListCubit();
      when(mockCubit.isAddedToWatchlist(any)).thenAnswer((Invocation inv) async => false);
      when(mockCubit.getWatchlistList()).thenAnswer((_) async => []);
      when(mockCubit.getDetail(any)).thenAnswer((Invocation inv) async => detail);
      when(mockCubit.getRecommendations(any)).thenAnswer((Invocation inv) async => recommendations);
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      when(mockCubit.state).thenReturn(TvSeriesListInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TvSeriesListCubit>.value(
            value: mockCubit,
            child: TvSeriesDetailPage(
              detail: detail,
              recommendations: recommendations,
            ),
          ),
        ),
      );

      expect(find.text('Test Series'), findsWidgets);
      expect(find.text('Overview'), findsWidgets);
      expect(find.text('Season 1'), findsOneWidget);
      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.text('Recommended Series'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
