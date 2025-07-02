import 'package:movie_app_dicoding/domain/entities/tv_series.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series_detail.dart';
import 'package:movie_app_dicoding/domain/repositories/tv_series_repository.dart';
import '../datasources/tv_series_remote_data_source.dart';
import '../datasources/tv_series_local_data_source.dart';
import '../models/tv_series_detail_model.dart';

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<TvSeries>> getPopularTvSeries() async {
    final result = await remoteDataSource.getPopularTvSeries();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<TvSeries>> getTopRatedTvSeries() async {
    final result = await remoteDataSource.getTopRatedTvSeries();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<TvSeries>> getNowPlayingTvSeries() async {
    final result = await remoteDataSource.getNowPlayingTvSeries();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<TvSeriesDetail> getTvSeriesDetail(int id) async {
    final result = await remoteDataSource.getTvSeriesDetail(id);
    return result.toEntity();
  }

  @override
  Future<List<TvSeries>> getTvSeriesRecommendations(int id) async {
    final result = await remoteDataSource.getTvSeriesRecommendations(id);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<TvSeries>> searchTvSeries(String query) async {
    final result = await remoteDataSource.searchTvSeries(query);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addToWatchlist(TvSeriesDetail tvSeriesDetail) async {
    final model = TvSeriesDetailModel(
      id: tvSeriesDetail.id,
      name: tvSeriesDetail.name,
      overview: tvSeriesDetail.overview,
      posterPath: tvSeriesDetail.posterPath,
      voteAverage: tvSeriesDetail.voteAverage,
      seasons: [], // Implementasi konversi season jika diperlukan
    );
    await localDataSource.addToWatchlist(model);
  }

  @override
  Future<void> removeFromWatchlist(int id) async {
    await localDataSource.removeFromWatchlist(id);
  }

  @override
  Future<List<TvSeries>> getWatchlist() async {
    final result = await localDataSource.getWatchlist();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    return await localDataSource.isAddedToWatchlist(id);
  }
}
