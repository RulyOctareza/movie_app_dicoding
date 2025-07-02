import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/episode.dart';
import '../cubit/tv_series_list_cubit.dart';
import 'tv_series_episode_detail_page.dart';

class TvSeriesEpisodeListPage extends StatelessWidget {
  final int tvId;
  final int seasonNumber;
  final String seasonName;

  const TvSeriesEpisodeListPage({
    super.key,
    required this.tvId,
    required this.seasonNumber,
    required this.seasonName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        title: Text(seasonName, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Episode>>(
        future: context.read<TvSeriesListCubit>().getSeasonEpisodes(
          tvId,
          seasonNumber,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load episodes'));
          }
          final episodes = snapshot.data ?? [];
          if (episodes.isEmpty) {
            return const Center(child: Text('No episodes found'));
          }
          return ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
              return ListTile(
                leading: episode.stillPath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w185${episode.stillPath}',
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.tv, color: Colors.white),
                title: Text(
                  episode.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Episode ${episode.episodeNumber}',
                  style: const TextStyle(color: Colors.white70),
                ),
                tileColor: const Color(0xFF232441),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TvSeriesEpisodeDetailPage(episode: episode),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
