import '../../domain/entities/episode.dart';

class EpisodeModel {
  final int id;
  final String name;
  final int episodeNumber;
  final String overview;
  final String stillPath;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.episodeNumber,
    required this.overview,
    required this.stillPath,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'],
      name: json['name'],
      episodeNumber: json['episode_number'],
      overview: json['overview'],
      stillPath: json['still_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'episode_number': episodeNumber,
      'overview': overview,
      'still_path': stillPath,
    };
  }

  Episode toEntity() {
    return Episode(
      id: id,
      name: name,
      episodeNumber: episodeNumber,
      overview: overview,
      stillPath: stillPath,
    );
  }
}
