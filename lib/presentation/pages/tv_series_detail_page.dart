import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series_detail.dart';
import 'package:movie_app_dicoding/presentation/cubit/tv_series_list_cubit.dart';
import '../../domain/entities/tv_series.dart';
import 'tv_series_episode_list_page.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final TvSeriesDetail detail;
  final List<TvSeries> recommendations;

  const TvSeriesDetailPage({
    super.key,
    required this.detail,
    required this.recommendations,
  });

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  bool _isInWatchlist = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkWatchlist();
  }

  Future<void> _checkWatchlist() async {
    final cubit = context.read<TvSeriesListCubit>();
    final isAdded = await cubit.isAddedToWatchlist(widget.detail.id);
    if (mounted) setState(() => _isInWatchlist = isAdded);
  }

  Future<void> _toggleWatchlist() async {
    setState(() => _loading = true);
    final cubit = context.read<TvSeriesListCubit>();
    if (_isInWatchlist) {
      await cubit.removeFromWatchlist(widget.detail.id);
    } else {
      await cubit.addToWatchlist(widget.detail);
    }
    await _checkWatchlist();
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isInWatchlist ? 'Added to Watchlist' : 'Removed from Watchlist',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.detail.name,
          style: const TextStyle(color: Colors.white),
        ),
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
                      final updated = await cubit.getWatchlistList();
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/watchlist',
                          arguments: {
                            'watchlist': updated,
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.detail.posterPath.isNotEmpty
                ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${widget.detail.posterPath}',
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Icon(Icons.tv, size: 120, color: Colors.white),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.detail.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isInWatchlist
                          ? Colors.grey
                          : Colors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _loading ? null : _toggleWatchlist,
                    icon: Icon(_isInWatchlist ? Icons.check : Icons.add),
                    label: Text(_isInWatchlist ? 'In Watchlist' : 'Watchlist'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    widget.detail.voteAverage.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Text(
                'Overview',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.detail.overview,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Text(
                'Seasons',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...widget.detail.seasons.map(
              (season) => Column(
                children: [
                  ListTile(
                    tileColor: const Color(0xFF232441),
                    title: Text(
                      season.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Episodes: ${season.episodeCount}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TvSeriesEpisodeListPage(
                            tvId: widget.detail.id,
                            seasonNumber: season.seasonNumber,
                            seasonName: season.name,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    color: Colors.white24,
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Text(
                'Recommendations',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.recommendations.length,
                itemBuilder: (context, index) {
                  final rec = widget.recommendations[index];
                  return GestureDetector(
                    onTap: () async {
                      final cubit = context.read<TvSeriesListCubit>();
                      final detail = await cubit.getDetail(rec.id);
                      final recs = await cubit.getRecommendations(rec.id);
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/detail',
                          arguments: {
                            'detail': detail,
                            'recommendations': recs,
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
                        children: [
                          rec.posterPath.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w185${rec.posterPath}',
                                    fit: BoxFit.cover,
                                    height: 120,
                                  ),
                                )
                              : const Icon(
                                  Icons.tv,
                                  size: 80,
                                  color: Colors.white,
                                ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              rec.name,
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
