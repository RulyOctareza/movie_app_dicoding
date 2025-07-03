import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

// TODO: Implement usecases for Movie (GetPopular, GetTopRated, GetNowPlaying, Search, GetDetail, GetRecommendations, Watchlist, etc)

class GetPopularMovies {
  final MovieRepository repository;
  GetPopularMovies(this.repository);
  Future<List<Movie>> call() => repository.getPopularMovies();
}

class GetTopRatedMovies {
  final MovieRepository repository;
  GetTopRatedMovies(this.repository);
  Future<List<Movie>> call() => repository.getTopRatedMovies();
}

class GetNowPlayingMovies {
  final MovieRepository repository;
  GetNowPlayingMovies(this.repository);
  Future<List<Movie>> call() => repository.getNowPlayingMovies();
}

class SearchMovies {
  final MovieRepository repository;
  SearchMovies(this.repository);
  Future<List<Movie>> call(String query) => repository.searchMovies(query);
}

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);
  Future<Movie> call(int id) => repository.getMovieDetail(id);
}

class GetMovieRecommendations {
  final MovieRepository repository;
  GetMovieRecommendations(this.repository);
  Future<List<Movie>> call(int id) => repository.getMovieRecommendations(id);
}

class GetMovieWatchlist {
  final MovieRepository repository;
  GetMovieWatchlist(this.repository);
  Future<List<Movie>> call() => repository.getMovieWatchlist();
}

class AddMovieToWatchlist {
  final MovieRepository repository;
  AddMovieToWatchlist(this.repository);
  Future<void> call(int movieId) => repository.addMovieToWatchlist(movieId);
}

class RemoveMovieFromWatchlist {
  final MovieRepository repository;
  RemoveMovieFromWatchlist(this.repository);
  Future<void> call(int movieId) =>
      repository.removeMovieFromWatchlist(movieId);
}

class IsMovieAddedToWatchlist {
  final MovieRepository repository;
  IsMovieAddedToWatchlist(this.repository);
  Future<bool> call(int movieId) => repository.isMovieAddedToWatchlist(movieId);
}
