// Entity untuk Season
class Season {
  final int id;
  final String name;
  final int seasonNumber;
  final int episodeCount;
  final String overview;
  final String posterPath;

  Season({
    required this.id,
    required this.name,
    required this.seasonNumber,
    required this.episodeCount,
    required this.overview,
    required this.posterPath,
  });
}
