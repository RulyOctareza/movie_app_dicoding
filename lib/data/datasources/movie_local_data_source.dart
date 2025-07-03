import 'package:shared_preferences/shared_preferences.dart';

abstract class MovieLocalDataSource {
  Future<List<int>> getWatchlistIds();
  Future<void> addToWatchlist(int movieId);
  Future<void> removeFromWatchlist(int movieId);
  Future<bool> isAddedToWatchlist(int movieId);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final SharedPreferences prefs;

  MovieLocalDataSourceImpl(this.prefs);

  static const watchlistKey = 'movie_watchlist';

  @override
  Future<List<int>> getWatchlistIds() async {
    final ids = prefs.getStringList(watchlistKey);
    if (ids == null) return [];
    return ids.map((e) => int.tryParse(e) ?? 0).where((e) => e != 0).toList();
  }

  @override
  Future<void> addToWatchlist(int movieId) async {
    final ids = await getWatchlistIds();
    if (!ids.contains(movieId)) {
      ids.add(movieId);
      await prefs.setStringList(
        watchlistKey,
        ids.map((e) => e.toString()).toList(),
      );
    }
  }

  @override
  Future<void> removeFromWatchlist(int movieId) async {
    final ids = await getWatchlistIds();
    ids.remove(movieId);
    await prefs.setStringList(
      watchlistKey,
      ids.map((e) => e.toString()).toList(),
    );
  }

  @override
  Future<bool> isAddedToWatchlist(int movieId) async {
    final ids = await getWatchlistIds();
    return ids.contains(movieId);
  }
}
