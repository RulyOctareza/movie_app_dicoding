import 'season.dart';

class TvSeriesDetail {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final List<Season> seasons;

  TvSeriesDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.seasons,
  });
}
