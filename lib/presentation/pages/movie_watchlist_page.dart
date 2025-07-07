import 'package:flutter/material.dart';

class RouteObserverProvider {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class MovieWatchlistPage extends StatefulWidget {
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
  State<MovieWatchlistPage> createState() => _MovieWatchlistPageState();
}

class _MovieWatchlistPageState extends State<MovieWatchlistPage>
    with RouteAware {
  List _watchlist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteObserverProvider.routeObserver.subscribe(
      this,
      ModalRoute.of(context) as PageRoute,
    );
    _watchlist = widget.watchlist;
  }

  @override
  void dispose() {
    RouteObserverProvider.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Trigger refresh when returning to this page
    setState(() {});
  }

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
      body: _watchlist.isEmpty
          ? const Center(
              child: Text(
                'No movies in watchlist',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: _watchlist.length,
              itemBuilder: (context, index) {
                final movie = _watchlist[index];
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
                        final messenger = ScaffoldMessenger.of(context);
                        await widget.onRemove(movie.id);
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Removed from Watchlist'),
                          ),
                        );
                        setState(() {});
                      },
                    ),
                    onTap: () async {
                      await widget.onTapDetail(movie.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
