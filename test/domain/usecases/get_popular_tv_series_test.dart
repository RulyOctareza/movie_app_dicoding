import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series.dart';
import 'package:movie_app_dicoding/domain/usecases/tv_series_usecases.dart';
import 'tv_series_repository_mock.mocks.dart';

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockRepository);
  });

  final tTvSeriesList = [
    TvSeries(
      id: 1,
      name: 'Test Series',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
    ),
  ];

  test('should get list of popular tv series from repository', () async {
    // arrange
    when(
      mockRepository.getPopularTvSeries(),
    ).thenAnswer((_) async => tTvSeriesList);
    // act
    final result = await usecase();
    // assert
    expect(result, tTvSeriesList);
    verify(mockRepository.getPopularTvSeries());
    verifyNoMoreInteractions(mockRepository);
  });
}
