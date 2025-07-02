import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tv_series_model.dart';
import '../models/tv_series_detail_model.dart';
import '../models/episode_model.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<List<TvSeriesModel>> getNowPlayingTvSeries();
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
  Future<List<EpisodeModel>> getSeasonEpisodes(int tvId, int seasonNumber);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  final http.Client client;
  final String apiKey;
  final String baseUrl;

  TvSeriesRemoteDataSourceImpl({
    required this.client,
    this.apiKey = '2174d146bb9c0eab47529b2e77d6b526',
    this.baseUrl = 'https://api.themoviedb.org/3',
  });

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/popular?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((e) => TvSeriesModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load popular TV series');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/top_rated?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((e) => TvSeriesModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load top rated TV series');
    }
  }

  @override
  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/on_the_air?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((e) => TvSeriesModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load now playing TV series');
    }
  }

  @override
  Future<TvSeriesDetailModel> getTvSeriesDetail(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return TvSeriesDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load TV series detail');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id/recommendations?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((e) => TvSeriesModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load TV series recommendations');
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$query'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((e) => TvSeriesModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to search TV series');
    }
  }

  @override
  Future<List<EpisodeModel>> getSeasonEpisodes(int tvId, int seasonNumber) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$tvId/season/$seasonNumber?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['episodes'] as List)
          .map((e) => EpisodeModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load episodes');
    }
  }
}
