import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/data/models/season_model.dart';

void main() {
  group('SeasonModel', () {
    test('fromJson dan toJson harus konsisten', () {
      final json = {
        'id': 1,
        'name': 'Season 1',
        'season_number': 1,
        'episode_count': 10,
        'overview': 'desc',
        'poster_path': '/season1.jpg',
      };
      final model = SeasonModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'Season 1');
      expect(model.seasonNumber, 1);
      expect(model.episodeCount, 10);
      expect(model.overview, 'desc');
      expect(model.posterPath, '/season1.jpg');
      expect(model.toJson(), json);
    });
  });
}
