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
  final List<Movie> watchlist;

  MovieListLoaded({
    required this.popular,
    required this.topRated,
    required this.nowPlaying,
    required this.watchlist,
  });

  @override
  List<Object?> get props => [popular, topRated, nowPlaying, watchlist];
}

class MovieWatchlistLoaded extends MovieListState {
  final List<Movie> movies;
  MovieWatchlistLoaded(this.movies);
  @override
  List<Object?> get props => [movies];
}

class MovieListError extends MovieListState {
  final String message;
  MovieListError(this.message);
  @override
  List<Object?> get props => [message];
}
