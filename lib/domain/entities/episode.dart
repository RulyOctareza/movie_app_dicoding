// Entity untuk Episode
class Episode {
  final int id;
  final String name;
  final int episodeNumber;
  final String overview;
  final String stillPath;

  Episode({
    required this.id,
    required this.name,
    required this.episodeNumber,
    required this.overview,
    required this.stillPath,
  });
}
