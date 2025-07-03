import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<Movie> getMovieDetail(int id);
  Future<List<Movie>> getMovieRecommendations(int id);
  Future<List<Movie>> searchMovies(String query);
  Future<List<Movie>> getMovieWatchlist();
  Future<void> addMovieToWatchlist(int movieId);
  Future<void> removeMovieFromWatchlist(int movieId);
  Future<bool> isMovieAddedToWatchlist(int movieId);
}
