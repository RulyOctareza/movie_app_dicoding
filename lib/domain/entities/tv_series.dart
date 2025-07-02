import 'package:equatable/equatable.dart';

// Entity utama untuk TV Series
class TvSeries extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;

  const TvSeries({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [id, name, overview, posterPath, voteAverage];
}
