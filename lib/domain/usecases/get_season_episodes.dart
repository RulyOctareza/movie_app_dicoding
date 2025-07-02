import '../entities/episode.dart';
import '../repositories/tv_series_repository.dart';

class GetSeasonEpisodes {
  final TvSeriesRepository repository;
  GetSeasonEpisodes(this.repository);

  Future<List<Episode>> call(int tvId, int seasonNumber) {
    return repository.getSeasonEpisodes(tvId, seasonNumber);
  }
}
