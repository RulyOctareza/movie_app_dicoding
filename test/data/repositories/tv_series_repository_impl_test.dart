import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_app_dicoding/data/repositories/tv_series_repository_impl.dart';
import 'package:movie_app_dicoding/data/models/tv_series_model.dart';
import 'tv_series_repository_impl_mock.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemote;
  late MockTvSeriesLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockTvSeriesRemoteDataSource();
    mockLocal = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    id: 1,
    name: 'Test Series',
    overview: 'Overview',
    posterPath: '/test.jpg',
    voteAverage: 8.0,
  );
  final tTvSeries = tTvSeriesModel.toEntity();
  final tTvSeriesModelList = [tTvSeriesModel];
  final tTvSeriesList = [tTvSeries];

  test('should return popular tv series from remote data source', () async {
    // arrange
    when(
      mockRemote.getPopularTvSeries(),
    ).thenAnswer((_) async => tTvSeriesModelList);
    // act
    final result = await repository.getPopularTvSeries();
    // assert
    expect(result, tTvSeriesList);
    verify(mockRemote.getPopularTvSeries());
    verifyNoMoreInteractions(mockRemote);
  });
}
