import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/data/models/tv_series_detail_model.dart';

void main() {
  group('TvSeriesDetailModel', () {
    test('fromJson dan toJson harus konsisten', () {
      final json = {
        'id': 1,
        'name': 'Test TV',
        'overview': 'desc',
        'poster_path': '/test.jpg',
        'vote_average': 8.0,
        'seasons': [],
      };
      final model = TvSeriesDetailModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'Test TV');
      expect(model.overview, 'desc');
      expect(model.posterPath, '/test.jpg');
      expect(model.voteAverage, 8.0);
      expect(model.seasons, isEmpty);
      expect(model.toJson(), json);
    });
  });
}
