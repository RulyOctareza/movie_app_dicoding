import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';
import '../datasources/movie_local_data_source.dart';
import '../../domain/entities/movie.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    final result = await remoteDataSource.getNowPlayingMovies();
    return result;
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    final result = await remoteDataSource.getPopularMovies();
    return result;
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    final result = await remoteDataSource.getTopRatedMovies();
    return result;
  }

  @override
  Future<Movie> getMovieDetail(int id) async {
    final result = await remoteDataSource.getMovieDetail(id);
    return result;
  }

  @override
  Future<List<Movie>> getMovieRecommendations(int id) async {
    final result = await remoteDataSource.getMovieRecommendations(id);
    return result;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final result = await remoteDataSource.searchMovies(query);
    return result;
  }

  @override
  Future<List<Movie>> getMovieWatchlist() async {
    final ids = await localDataSource.getWatchlistIds();
    final movies = <Movie>[];
    for (final id in ids) {
      try {
        final movie = await remoteDataSource.getMovieDetail(id);
        movies.add(movie);
      } catch (_) {}
    }
    return movies;
  }

  @override
  Future<void> addMovieToWatchlist(int movieId) async {
    await localDataSource.addToWatchlist(movieId);
  }

  @override
  Future<void> removeMovieFromWatchlist(int movieId) async {
    await localDataSource.removeFromWatchlist(movieId);
  }

  @override
  Future<bool> isMovieAddedToWatchlist(int movieId) async {
    return localDataSource.isAddedToWatchlist(movieId);
  }
}
