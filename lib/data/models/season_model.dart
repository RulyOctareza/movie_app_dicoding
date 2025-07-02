import '../../domain/entities/season.dart';

class SeasonModel {
  final int id;
  final String name;
  final int seasonNumber;
  final int episodeCount;
  final String overview;
  final String posterPath;

  SeasonModel({
    required this.id,
    required this.name,
    required this.seasonNumber,
    required this.episodeCount,
    required this.overview,
    required this.posterPath,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'],
      name: json['name'],
      seasonNumber: json['season_number'],
      episodeCount: json['episode_count'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'season_number': seasonNumber,
      'episode_count': episodeCount,
      'overview': overview,
      'poster_path': posterPath,
    };
  }

  Season toEntity() {
    return Season(
      id: id,
      name: name,
      seasonNumber: seasonNumber,
      episodeCount: episodeCount,
      overview: overview,
      posterPath: posterPath,
    );
  }
}
