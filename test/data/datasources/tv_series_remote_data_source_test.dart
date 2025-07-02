import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_dicoding/data/datasources/tv_series_remote_data_source.dart';
import 'package:movie_app_dicoding/data/models/tv_series_model.dart';
import 'package:mockito/mockito.dart';
import 'tv_series_remote_data_source_mock.mocks.dart';

void main() {
  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  final tTvSeriesModel = TvSeriesModel(
    id: 1,
    name: 'Test Series',
    overview: 'Overview',
    posterPath: '/test.jpg',
    voteAverage: 8.0,
  );
  final tTvSeriesModelList = [tTvSeriesModel];

  group('getPopularTvSeries', () {
    test('should return List<TvSeriesModel> when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
        json.encode({
          'results': [
            {
              'id': 1,
              'name': 'Test Series',
              'overview': 'Overview',
              'poster_path': '/test.jpg',
              'vote_average': 8.0,
            }
          ]
        }),
        200,
      ));
      // act
      final result = await dataSource.getPopularTvSeries();
      // assert
      expect(result, equals(tTvSeriesModelList));
    });

    test('should throw Exception when the response code is not 200', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvSeries();
      // assert
      expect(() => call, throwsA(isA<Exception>()));
    });
  });
}
