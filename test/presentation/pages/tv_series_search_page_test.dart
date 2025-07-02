import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/presentation/pages/tv_series_search_page.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_cubit.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_state.dart';
import 'tv_series_home_page_mock.mocks.dart';

void main() {
  group('TvSeriesSearchPage Widget Test', () {
    late MockTvSeriesListCubit mockCubit;
    setUp(() {
      mockCubit = MockTvSeriesListCubit();
    });

    testWidgets('menampilkan hasil pencarian', (WidgetTester tester) async {
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: [], topRated: [], nowPlaying: []));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TvSeriesListCubit>.value(
            value: mockCubit,
            child: const TvSeriesSearchPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      // Tambahkan expect lain sesuai UI hasil pencarian
    });

    testWidgets('menampilkan error state', (WidgetTester tester) async {
      when(mockCubit.search(any)).thenThrow(Exception('Error test'));
      when(mockCubit.state).thenReturn(TvSeriesListLoaded(popular: [], topRated: [], nowPlaying: []));
      when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TvSeriesListCubit>.value(
            value: mockCubit,
            child: const TvSeriesSearchPage(),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.textContaining('Exception: Error test'), findsOneWidget);
    });
  });
}
