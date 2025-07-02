import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/presentation/pages/tv_series_episode_detail_page.dart';
import 'package:movie_app_dicoding/domain/entities/episode.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('TvSeriesEpisodeDetailPage Widget Test', () {
    final episode = Episode(
      id: 1,
      name: 'Episode 1',
      overview: 'Deskripsi episode 1',
      episodeNumber: 1,
      stillPath: '/ep1.jpg',
    );

    testWidgets('menampilkan detail episode dengan gambar', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: TvSeriesEpisodeDetailPage(episode: episode),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Episode 1'), findsWidgets); // judul bisa muncul lebih dari sekali
        expect(find.text('Deskripsi episode 1'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testWidgets('menampilkan icon jika tidak ada gambar', (WidgetTester tester) async {
      final episodeNoImage = Episode(
        id: 2,
        name: 'Episode 2',
        overview: '',
        episodeNumber: 2,
        stillPath: '',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: TvSeriesEpisodeDetailPage(episode: episodeNoImage),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.tv), findsOneWidget);
      expect(find.text('No overview available.'), findsOneWidget);
    });
  });
}
