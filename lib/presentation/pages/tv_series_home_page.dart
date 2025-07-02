import 'package:flutter/material.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_state.dart';
import '../cubit/tv_series_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesHomePage extends StatelessWidget {
  const TvSeriesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
        title: const Text('Ditonton', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () async {
              final cubit = context.read<TvSeriesListCubit>();
              final watchlist = await cubit.getWatchlistList();
              if (context.mounted) {
                Navigator.pushNamed(
                  context,
                  '/watchlist',
                  arguments: {
                    'watchlist': watchlist,
                    'onRemove': (int id) async {
                      await cubit.removeFromWatchlist(id);
                    },
                    'onTapDetail': (int id) async {
                      final detail = await cubit.getDetail(id);
                      final recs = await cubit.getRecommendations(id);
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          '/detail',
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
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ],
      ),
      body: BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
        builder: (context, state) {
          if (state is TvSeriesListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TvSeriesListLoaded) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              children: [
                _buildSection(
                  context,
                  'Now Playing',
                  state.nowPlaying,
                  '/category',
                ),
                _buildSection(context, 'Popular', state.popular, '/category'),
                _buildSection(
                  context,
                  'Top Rated',
                  state.topRated,
                  '/category',
                ),
              ],
            );
          } else if (state is TvSeriesListError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TvSeriesListCubit>().fetchAll(),
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
                    arguments: {'title': title, 'tvSeriesList': items},
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
              final tv = items[index];
              return GestureDetector(
                onTap: () async {
                  final cubit = context.read<TvSeriesListCubit>();
                  final detail = await cubit.getDetail(tv.id);
                  final recommendations = await cubit.getRecommendations(tv.id);
                  if (context.mounted) {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: {
                        'detail': detail,
                        'recommendations': recommendations,
                      },
                    );
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
                          child: tv.posterPath.isNotEmpty
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w185${tv.posterPath}',
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.tv,
                                  size: 80,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          tv.name,
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
