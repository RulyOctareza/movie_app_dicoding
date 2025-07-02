import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/data/models/episode_model.dart';

void main() {
  group('EpisodeModel', () {
    test('fromJson dan toJson harus konsisten', () {
      final json = {
        'id': 1,
        'name': 'Episode 1',
        'overview': 'desc',
        'episode_number': 1,
        'still_path': '/ep1.jpg',
      };
      final model = EpisodeModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'Episode 1');
      expect(model.overview, 'desc');
      expect(model.episodeNumber, 1);
      expect(model.stillPath, '/ep1.jpg');
      expect(model.toJson(), json);
    });
  });
}
