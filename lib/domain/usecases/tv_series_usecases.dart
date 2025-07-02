import '../entities/tv_series.dart';
import '../entities/tv_series_detail.dart';
import '../repositories/tv_series_repository.dart';

class GetPopularTvSeries {
  final TvSeriesRepository repository;
  GetPopularTvSeries(this.repository);

  Future<List<TvSeries>> call() {
    return repository.getPopularTvSeries();
  }
}

class GetTopRatedTvSeries {
  final TvSeriesRepository repository;
  GetTopRatedTvSeries(this.repository);

  Future<List<TvSeries>> call() {
    return repository.getTopRatedTvSeries();
  }
}

class GetNowPlayingTvSeries {
  final TvSeriesRepository repository;
  GetNowPlayingTvSeries(this.repository);

  Future<List<TvSeries>> call() {
    return repository.getNowPlayingTvSeries();
  }
}

class GetTvSeriesDetail {
  final TvSeriesRepository repository;
  GetTvSeriesDetail(this.repository);

  Future<TvSeriesDetail> call(int id) {
    return repository.getTvSeriesDetail(id);
  }
}

class GetTvSeriesRecommendations {
  final TvSeriesRepository repository;
  GetTvSeriesRecommendations(this.repository);

  Future<List<TvSeries>> call(int id) {
    return repository.getTvSeriesRecommendations(id);
  }
}

class SearchTvSeries {
  final TvSeriesRepository repository;
  SearchTvSeries(this.repository);

  Future<List<TvSeries>> call(String query) {
    return repository.searchTvSeries(query);
  }
}

class AddToWatchlist {
  final TvSeriesRepository repository;
  AddToWatchlist(this.repository);

  Future<void> call(TvSeriesDetail tvSeriesDetail) {
    return repository.addToWatchlist(tvSeriesDetail);
  }
}

class RemoveFromWatchlist {
  final TvSeriesRepository repository;
  RemoveFromWatchlist(this.repository);

  Future<void> call(int id) {
    return repository.removeFromWatchlist(id);
  }
}

class GetWatchlist {
  final TvSeriesRepository repository;
  GetWatchlist(this.repository);

  Future<List<TvSeries>> call() {
    return repository.getWatchlist();
  }
}

class IsAddedToWatchlist {
  final TvSeriesRepository repository;
  IsAddedToWatchlist(this.repository);

  Future<bool> call(int id) {
    return repository.isAddedToWatchlist(id);
  }
}
