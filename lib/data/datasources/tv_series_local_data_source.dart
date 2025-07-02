import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tv_series_detail_model.dart';
import '../models/tv_series_model.dart';

abstract class TvSeriesLocalDataSource {
  Future<void> addToWatchlist(TvSeriesDetailModel tvSeriesDetail);
  Future<void> removeFromWatchlist(int id);
  Future<List<TvSeriesModel>> getWatchlist();
  Future<bool> isAddedToWatchlist(int id);
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final SharedPreferences prefs;
  static const String watchlistKey = 'tv_series_watchlist';

  TvSeriesLocalDataSourceImpl(this.prefs);

  @override
  Future<void> addToWatchlist(TvSeriesDetailModel tvSeriesDetail) async {
    final watchlist = prefs.getStringList(watchlistKey) ?? [];
    final updated = List<String>.from(watchlist)
      ..add(json.encode(tvSeriesDetail.toJson()));
    await prefs.setStringList(watchlistKey, updated);
  }

  @override
  Future<void> removeFromWatchlist(int id) async {
    final watchlist = prefs.getStringList(watchlistKey) ?? [];
    final updated = watchlist.where((item) {
      final map = json.decode(item);
      return map['id'] != id;
    }).toList();
    await prefs.setStringList(watchlistKey, updated);
  }

  @override
  Future<List<TvSeriesModel>> getWatchlist() async {
    final watchlist = prefs.getStringList(watchlistKey) ?? [];
    return watchlist.map((item) {
      final map = json.decode(item);
      return TvSeriesModel.fromJson(map);
    }).toList();
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final watchlist = prefs.getStringList(watchlistKey) ?? [];
    return watchlist.any((item) {
      final map = json.decode(item);
      return map['id'] == id;
    });
  }
}
