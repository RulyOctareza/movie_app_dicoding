import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tv_series.dart';
import '../cubit/tv_series_list_cubit.dart';
import '../cubit/tv_series_list_state.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({
    super.key,
    required watchlist,
    required onTapDetail,
    required onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
        title: const Text('Watchlist', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<TvSeriesListCubit, TvSeriesListState>(
        builder: (context, state) {
          List<TvSeries> watchlist = [];
          if (state is TvSeriesListLoaded) {
            watchlist = state.watchlist;
          } else if (state is TvSeriesWatchlistLoaded) {
            watchlist = state.watchlist;
          }
          if (state is TvSeriesListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TvSeriesListLoaded ||
              state is TvSeriesWatchlistLoaded) {
            if (watchlist.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada TV Series di watchlist',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            return ListView.builder(
              itemCount: watchlist.length,
              itemBuilder: (context, index) {
                final tv = watchlist[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232441),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: tv.posterPath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w92${tv.posterPath}',
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.tv, color: Colors.white),
                    title: Text(
                      tv.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Rating: ${tv.voteAverage}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await context
                            .read<TvSeriesListCubit>()
                            .removeFromWatchlist(tv.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from Watchlist'),
                          ),
                        );
                      },
                    ),
                    onTap: () async {
                      final cubit = context.read<TvSeriesListCubit>();
                      final detail = await cubit.getDetail(tv.id);
                      final recommendations = await cubit.getRecommendations(
                        tv.id,
                      );
                      if (!context.mounted) return;
                      Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: {
                          'detail': detail,
                          'recommendations': recommendations,
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is TvSeriesListError) {
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
    );
  }
}
