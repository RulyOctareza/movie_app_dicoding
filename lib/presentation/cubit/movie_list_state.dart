part of 'movie_list_cubit.dart';

abstract class MovieListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListLoaded extends MovieListState {
  final List<Movie> popular;
  final List<Movie> topRated;
  final List<Movie> nowPlaying;

  MovieListLoaded({
    required this.popular,
    required this.topRated,
    required this.nowPlaying,
  });

  @override
  List<Object?> get props => [popular, topRated, nowPlaying];
}

class MovieListError extends MovieListState {
  final String message;
  MovieListError(this.message);
  @override
  List<Object?> get props => [message];
}
