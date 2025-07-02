import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app_dicoding/data/datasources/tv_series_remote_data_source.dart';
import 'package:movie_app_dicoding/data/models/tv_series_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'tv_series_remote_data_source_mock.mocks.dart';
import 'dart:convert';

void main() {
  group('TvSeriesRemoteDataSourceImpl', () {
    late MockClient mockHttpClient;
    late TvSeriesRemoteDataSourceImpl dataSource;
    setUp(() {
      mockHttpClient = MockClient();
      dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
    });

    test('getPopularTvSeries returns list when response 200', () async {
      final responseJson = jsonEncode({
        'results': [
          {
            'id': 1,
            'name': 'Test TV',
            'overview': 'desc',
            'poster_path': '/test.jpg',
            'vote_average': 8.0,
          },
        ],
      });
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response(responseJson, 200));
      final result = await dataSource.getPopularTvSeries();
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.first.name, 'Test TV');
    });

    test('getPopularTvSeries throws Exception on error', () async {
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response('error', 404));
      expect(() => dataSource.getPopularTvSeries(), throwsException);
    });

    test('getTopRatedTvSeries returns list when response 200', () async {
      final responseJson = jsonEncode({
        'results': [
          {
            'id': 2,
            'name': 'Top Rated TV',
            'overview': 'desc',
            'poster_path': '/top.jpg',
            'vote_average': 9.0,
          },
        ],
      });
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response(responseJson, 200));
      final result = await dataSource.getTopRatedTvSeries();
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.first.name, 'Top Rated TV');
    });

    test('getTopRatedTvSeries throws Exception on error', () async {
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response('error', 404));
      expect(() => dataSource.getTopRatedTvSeries(), throwsException);
    });

    test('getNowPlayingTvSeries returns list when response 200', () async {
      final responseJson = jsonEncode({
        'results': [
          {
            'id': 3,
            'name': 'Now Playing TV',
            'overview': 'desc',
            'poster_path': '/now.jpg',
            'vote_average': 7.5,
          },
        ],
      });
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response(responseJson, 200));
      final result = await dataSource.getNowPlayingTvSeries();
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.first.name, 'Now Playing TV');
    });

    test('getNowPlayingTvSeries throws Exception on error', () async {
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response('error', 404));
      expect(() => dataSource.getNowPlayingTvSeries(), throwsException);
    });

    test('getTvSeriesDetail returns detail when response 200', () async {
      final responseJson = jsonEncode({
        'id': 1,
        'name': 'Detail TV',
        'overview': 'desc',
        'poster_path': '/detail.jpg',
        'vote_average': 8.5,
        'genres': [],
        'seasons': [],
      });
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response(responseJson, 200));
      final result = await dataSource.getTvSeriesDetail(1);
      expect(result.name, 'Detail TV');
    });

    test('getTvSeriesDetail throws Exception on error', () async {
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response('error', 404));
      expect(() => dataSource.getTvSeriesDetail(1), throwsException);
    });

    test('getTvSeriesRecommendations returns list when response 200', () async {
      final responseJson = jsonEncode({
        'results': [
          {
            'id': 4,
            'name': 'Rekomendasi TV',
            'overview': 'desc',
            'poster_path': '/rec.jpg',
            'vote_average': 7.0,
          },
        ],
      });
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response(responseJson, 200));
      final result = await dataSource.getTvSeriesRecommendations(1);
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.first.name, 'Rekomendasi TV');
    });

    test('getTvSeriesRecommendations throws Exception on error', () async {
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response('error', 404));
      expect(() => dataSource.getTvSeriesRecommendations(1), throwsException);
    });

    test('searchTvSeries returns list when response 200', () async {
      final responseJson = jsonEncode({
        'results': [
          {
            'id': 5,
            'name': 'Search TV',
            'overview': 'desc',
            'poster_path': '/search.jpg',
            'vote_average': 6.5,
          },
        ],
      });
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response(responseJson, 200));
      final result = await dataSource.searchTvSeries('search');
      expect(result, isA<List<TvSeriesModel>>());
      expect(result.first.name, 'Search TV');
    });

    test('searchTvSeries throws Exception on error', () async {
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response('error', 404));
      expect(() => dataSource.searchTvSeries('search'), throwsException);
    });

    test('getSeasonEpisodes returns list when response 200', () async {
      final responseJson = jsonEncode({
        'episodes': [
          {
            'id': 6,
            'name': 'Episode 1',
            'overview': 'desc',
            'episode_number': 1,
            'still_path': '/ep1.jpg',
          },
        ],
      });
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response(responseJson, 200));
      final result = await dataSource.getSeasonEpisodes(1, 1);
      expect(result, isA<List>());
      expect(result.first.name, 'Episode 1');
    });

    test('getSeasonEpisodes throws Exception on error', () async {
      when(
        mockHttpClient.get(argThat(isA<Uri>())),
      ).thenAnswer((_) async => http.Response('error', 404));
      expect(() => dataSource.getSeasonEpisodes(1, 1), throwsException);
    });
  });
}
