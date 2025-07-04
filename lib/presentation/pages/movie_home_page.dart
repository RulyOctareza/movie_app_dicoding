import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/movie_list_cubit.dart';

class MovieHomePage extends StatelessWidget {
  const MovieHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () async {
              final cubit = context.read<MovieListCubit>();
              final watchlist = await cubit.fetchWatchlistList();
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  '/movie_watchlist',
                  arguments: {
                    'watchlist': watchlist,
                    'onRemove': (int id) async {
                      await cubit.removeFromWatchlist(id);
                    },
                    'onTapDetail': (int id) async {
                      final detail = await cubit.fetchDetail(id);
                      final recs = await cubit.fetchRecommendations(id);
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          '/movie_detail',
                          arguments: {
                            'detail': detail,
                            'recommendations': recs,
                          },
                        );
                      }
                    },
                  },
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/movie_search'),
          ),
          // TextButton(
          //   onPressed: () => throw Exception(),
          //   child: const Text("Throw Test Exception"),
          // ),
        ],
      ),
      body: BlocBuilder<MovieListCubit, MovieListState>(
        builder: (context, state) {
          if (state is MovieListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieListLoaded) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              children: [
                _buildSection(
                  context,
                  'Now Playing',
                  state.nowPlaying,
                  '/movie_category',
                ),
                _buildSection(
                  context,
                  'Popular',
                  state.popular,
                  '/movie_category',
                ),
                _buildSection(
                  context,
                  'Top Rated',
                  state.topRated,
                  '/movie_category',
                ),
              ],
            );
          } else if (state is MovieListError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<MovieListCubit>().fetchAll(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List items,
    String route,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    route,
                    arguments: {'title': title, 'movies': items},
                  );
                },
                child: const Text(
                  'See More',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final movie = items[index];
              return GestureDetector(
                onTap: () async {
                  final cubit = context.read<MovieListCubit>();
                  try {
                    final detail = await cubit.fetchDetail(movie.id);
                    final recommendations = await cubit.fetchRecommendations(
                      movie.id,
                    );
                    if (context.mounted) {
                      Navigator.pushNamed(
                        context,
                        '/movie_detail',
                        arguments: {
                          'detail': detail,
                          'recommendations': recommendations,
                        },
                      );
                    }
                  } catch (e) {
                    // Handle error if needed
                  }
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
                          child: movie.posterPath.isNotEmpty
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w185${movie.posterPath}',
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
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
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
    );
  }
}
