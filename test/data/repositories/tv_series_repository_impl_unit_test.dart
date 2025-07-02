import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/data/repositories/tv_series_repository_impl.dart';
import 'package:movie_app_dicoding/data/datasources/tv_series_remote_data_source.dart';
import 'package:movie_app_dicoding/data/datasources/tv_series_local_data_source.dart';
import 'package:movie_app_dicoding/data/models/tv_series_model.dart';
import 'package:movie_app_dicoding/domain/entities/tv_series.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements TvSeriesRemoteDataSource {}
class MockLocalDataSource extends Mock implements TvSeriesLocalDataSource {}

void main() {
  group('TvSeriesRepositoryImpl', () {
    late TvSeriesRepositoryImpl repository;
    late MockRemoteDataSource mockRemote;
    late MockLocalDataSource mockLocal;

    setUp(() {
      mockRemote = MockRemoteDataSource();
      when(mockRemote.getPopularTvSeries()).thenAnswer((_) async => [TvSeriesModel(id: 1, name: 'Test TV', overview: 'desc', posterPath: '/test.jpg', voteAverage: 8.0)]);
      mockLocal = MockLocalDataSource();
      repository = TvSeriesRepositoryImpl(
        remoteDataSource: mockRemote,
        localDataSource: mockLocal,
      );
    });

    tearDown(() {
      reset(mockRemote);
    });

    // test('getPopularTvSeries returns entity list', () async {
    //   final model = TvSeriesModel(id: 1, name: 'Test TV', overview: 'desc', posterPath: '/test.jpg', voteAverage: 8.0);
    //   when(mockRemote.getPopularTvSeries()).thenAnswer((_) async => [model]);
    //   final result = await repository.getPopularTvSeries();
    //   expect(result, isA<List<TvSeries>>());
    //   expect(result.first.name, 'Test TV');
    // });

    // test('getPopularTvSeries returns empty list if remote empty', () async {
    //   when(mockRemote.getPopularTvSeries()).thenAnswer((_) async => []);
    //   final result = await repository.getPopularTvSeries();
    //   expect(result, isA<List<TvSeries>>());
    //   expect(result, isEmpty);
    // });
  });
}
