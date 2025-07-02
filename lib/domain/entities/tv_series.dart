// Entity utama untuk TV Series
class TvSeries {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;

  TvSeries({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });
}
