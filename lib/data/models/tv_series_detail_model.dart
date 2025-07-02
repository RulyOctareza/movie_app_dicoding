import 'package:movie_app_dicoding/domain/entities/tv_series_detail.dart';

import 'season_model.dart';

class TvSeriesDetailModel {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final List<SeasonModel> seasons;

  TvSeriesDetailModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.seasons,
  });

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) {
    return TvSeriesDetailModel(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      seasons: (json['seasons'] as List)
          .map((e) => SeasonModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': voteAverage,
      'seasons': seasons.map((e) => e.toJson()).toList(),
    };
  }

  toEntity() {
    return TvSeriesDetail(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
      seasons: seasons.map((e) => e.toEntity()).toList(),
    );
  }
}
