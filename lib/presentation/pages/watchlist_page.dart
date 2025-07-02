import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tv_series.dart';
import '../cubit/tv_series_list_cubit.dart';

class WatchlistPage extends StatelessWidget {
  final List<TvSeries> watchlist;
  final Function(int) onRemove;
  final Function(int) onTapDetail;

  const WatchlistPage({
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
        elevation: 0,
        title: const Text('Watchlist', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: watchlist.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada TV Series di watchlist',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
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
                        // Hapus dari watchlist
                        final currentContext = context;
                        await onRemove(tv.id);
                        // Refresh halaman setelah hapus
                        if (currentContext.mounted) {
                          final cubit = currentContext.read<TvSeriesListCubit>();
                          final updated = await cubit.getWatchlistList();
                          if (currentContext.mounted) {
                            Navigator.pop(currentContext);
                            Navigator.pushNamed(
                              currentContext,
                              '/watchlist',
                              arguments: {
                                'watchlist': updated,
                                'onRemove': onRemove,
                                'onTapDetail': onTapDetail,
                              },
                            );
                          }
                        }
                      },
                    ),
                    onTap: () async {
                      final cubit = context.read<TvSeriesListCubit>();
                      final detail = await cubit.getDetail(tv.id);
                      final recommendations = await cubit.getRecommendations(
                        tv.id,
                      );
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
                  ),
                );
              },
            ),
    );
  }
}
