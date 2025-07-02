import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/presentation/pages/watchlist_page.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_cubit.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_state.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'tv_series_home_page_mock.mocks.dart';

void main() {
  group('WatchlistPage Widget Test', () {
    late MockTvSeriesListCubit mockCubit;
    setUp(() {
      mockCubit = MockTvSeriesListCubit();
    });

    testWidgets('menampilkan daftar watchlist', (WidgetTester tester) async {
      final tvList = [
        TvSeries(id: 1, name: 'Watchlist TV', overview: 'desc', posterPath: '/test.jpg', voteAverage: 8.0),
      ];
      when(mockCubit.getWatchlistList()).thenAnswer((_) async => tvList);
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: [], topRated: [], nowPlaying: []));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: WatchlistPage(watchlist: tvList, onRemove: (_) async {}, onTapDetail: (_) async {}),
            ),
          ),
        );
        expect(find.text('Watchlist TV'), findsOneWidget);
      });
    });

    testWidgets('menampilkan pesan kosong jika watchlist kosong', (WidgetTester tester) async {
      when(mockCubit.getWatchlistList()).thenAnswer((_) async => []);
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: [], topRated: [], nowPlaying: []));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<TvSeriesListCubit>.value(
              value: mockCubit,
              child: WatchlistPage(watchlist: [], onRemove: (_) async {}, onTapDetail: (_) async {}),
            ),
          ),
        );
        expect(find.textContaining('Tidak ada'), findsOneWidget);
      });
    });
  });
}
