import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/domain/usecases/movie_usecases.dart';
import 'movie_repository_mock.mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockRepo;

  setUp(() {
    mockRepo = MockMovieRepository();
    usecase = GetPopularMovies(mockRepo);
  });

  test('should call getPopularMovies on repository', () async {
    when(mockRepo.getPopularMovies()).thenAnswer((_) async => []);
    await usecase();
    verify(mockRepo.getPopularMovies());
  });
}
