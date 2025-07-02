import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/data/datasources/tv_series_local_data_source.dart';
import 'package:movie_app_dicoding/data/models/tv_series_detail_model.dart';
import 'package:movie_app_dicoding/data/models/tv_series_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TvSeriesLocalDataSourceImpl', () {
    late SharedPreferences prefs;
    late TvSeriesLocalDataSourceImpl dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      dataSource = TvSeriesLocalDataSourceImpl(prefs);
    });

    test('add, get, and remove watchlist', () async {
      final tvDetail = TvSeriesDetailModel(
        id: 1,
        name: 'Test TV',
        overview: 'desc',
        posterPath: '/test.jpg',
        voteAverage: 8.0,
        seasons: [],
      );
      await dataSource.addToWatchlist(tvDetail);
      final watchlist = await dataSource.getWatchlist();
      expect(watchlist, isA<List<TvSeriesModel>>());
      expect(watchlist.first.name, 'Test TV');
      await dataSource.removeFromWatchlist(1);
      final afterRemove = await dataSource.getWatchlist();
      expect(afterRemove, isEmpty);
    });
  });
}
