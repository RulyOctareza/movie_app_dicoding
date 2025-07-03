import 'package:flutter/material.dart';

class MovieWatchlistPage extends StatelessWidget {
  final List watchlist;
  final Future<void> Function(int) onRemove;
  final Future<void> Function(int) onTapDetail;
  const MovieWatchlistPage({
    super.key,
    required this.watchlist,
    required this.onRemove,
    required this.onTapDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        title: const Text(
          'Movie Watchlist',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: watchlist.isEmpty
          ? const Center(
              child: Text(
                'No movies in watchlist',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: watchlist.length,
              itemBuilder: (context, index) {
                final movie = watchlist[index];
                return Card(
                  color: const Color(0xFF232441),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading:
                        movie.posterPath != null && movie.posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          )
                        : const Icon(Icons.movie, color: Colors.white),
                    title: Text(
                      movie.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      movie.releaseDate ?? '-',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await onRemove(movie.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from Watchlist'),
                          ),
                        );
                      },
                    ),
                    onTap: () async {
                      await onTapDetail(movie.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
