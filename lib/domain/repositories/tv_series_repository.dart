import '../entities/tv_series.dart';
import '../entities/tv_series_detail.dart';

abstract class TvSeriesRepository {
  Future<List<TvSeries>> getPopularTvSeries();
  Future<List<TvSeries>> getTopRatedTvSeries();
  Future<List<TvSeries>> getNowPlayingTvSeries();
  Future<TvSeriesDetail> getTvSeriesDetail(int id);
  Future<List<TvSeries>> getTvSeriesRecommendations(int id);
  Future<List<TvSeries>> searchTvSeries(String query);
  Future<void> addToWatchlist(TvSeriesDetail tvSeriesDetail);
  Future<void> removeFromWatchlist(int id);
  Future<List<TvSeries>> getWatchlist();
  Future<bool> isAddedToWatchlist(int id);
}
