import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series.dart';

class TvSeriesModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;

  const TvSeriesModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) {
    return TvSeriesModel(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': voteAverage,
    };
  }

  TvSeries toEntity() {
    return TvSeries(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
    );
  }

  @override
  List<Object?> get props => [id, name, overview, posterPath, voteAverage];
}
