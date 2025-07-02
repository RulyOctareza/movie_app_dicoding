import 'package:flutter/material.dart';
import '../../domain/entities/episode.dart';

class TvSeriesEpisodeDetailPage extends StatelessWidget {
  final Episode episode;

  const TvSeriesEpisodeDetailPage({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          episode.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            episode.stillPath.isNotEmpty
                ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${episode.stillPath}',
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Icon(Icons.tv, size: 120, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'Episode ${episode.episodeNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              episode.overview.isNotEmpty ? episode.overview : 'No overview available.',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
