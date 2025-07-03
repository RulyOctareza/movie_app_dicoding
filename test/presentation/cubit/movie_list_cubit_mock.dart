import 'package:movie_app_dicoding/domain/usecases/movie_usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:movie_app_dicoding/domain/repositories/movie_repository.dart';

@GenerateMocks([
  MovieRepository,
  GetPopularMovies,
  GetTopRatedMovies,
  GetNowPlayingMovies,
  SearchMovies,
  GetMovieDetail,
  GetMovieRecommendations,
  GetMovieWatchlist,
  AddMovieToWatchlist,
  RemoveMovieFromWatchlist,
  IsMovieAddedToWatchlist,
])
void main() {}
