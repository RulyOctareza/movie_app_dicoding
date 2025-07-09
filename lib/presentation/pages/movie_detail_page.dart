import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_list_cubit.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic detail;
  final List recommendations;
  const MovieDetailPage({
    super.key,
    required this.detail,
    required this.recommendations,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final recommendations = widget.recommendations;
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
        title: Text(detail.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MovieListCubit, MovieListState>(
        builder: (context, state) {
          bool isInWatchlist = false;
          if (state is MovieListLoaded) {
            isInWatchlist = state.watchlist.any((m) => m.id == detail.id);
          } else if (state is MovieWatchlistLoaded) {
            isInWatchlist = state.movies.any((m) => m.id == detail.id);
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: detail.posterPath.isNotEmpty
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w342${detail.posterPath}',
                              height: 300,
                            )
                          : const Icon(
                              Icons.movie,
                              size: 120,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    detail.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        detail.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        detail.releaseDate,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          icon: Icon(
                            isInWatchlist ? Icons.bookmark : Icons.bookmark_add,
                          ),
                          label: Text(
                            isInWatchlist
                                ? 'Remove from Watchlist'
                                : 'Add to Watchlist',
                          ),
                          onPressed: () async {
                            setState(() => _loading = true);
                            final cubit = context.read<MovieListCubit>();
                            if (isInWatchlist) {
                              await cubit.removeFromWatchlist(detail.id);
                              if (!mounted) return;
                              setState(() => _loading = false);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Removed from Watchlist'),
                                ),
                              );
                            } else {
                              await cubit.addToWatchlist(detail.id);
                              if (!mounted) return;
                              setState(() => _loading = false);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to Watchlist'),
                                ),
                              );
                            }
                          },
                        ),
                  const SizedBox(height: 16),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail.overview,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Recommendations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (recommendations.isEmpty)
                    const Center(
                      child: Text(
                        'No recommendations found',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  else
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          final rec = recommendations[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/movie_detail',
                                arguments: {
                                  'detail': rec,
                                  'recommendations': recommendations,
                                },
                              );
                            },
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF232441),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: rec.posterPath.isNotEmpty
                                          ? Image.network(
                                              'https://image.tmdb.org/t/p/w185${rec.posterPath}',
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.movie,
                                              size: 80,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      rec.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
