import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/datasources/tv_series_local_data_source.dart';
import 'data/datasources/tv_series_remote_data_source.dart';
import 'data/repositories/tv_series_repository_impl.dart';
import 'domain/usecases/tv_series_usecases.dart';
import 'presentation/cubit/tv_series_list_cubit.dart';
import 'presentation/pages/tv_series_category_page.dart';
import 'presentation/pages/tv_series_detail_page.dart';
import 'presentation/pages/tv_series_home_page.dart';
import 'presentation/pages/tv_series_search_page.dart';
import 'presentation/pages/watchlist_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<Map<String, dynamic>> _initDependencies() async {
    final client = http.Client();
    final prefs = await SharedPreferences.getInstance();
    // Load API key from .env
    final apiKey = dotenv.env['api_key'] ?? '2174d146bb9c0eab47529b2e77d6b526';
    final remote = TvSeriesRemoteDataSourceImpl(client: client, apiKey: apiKey);
    final local = TvSeriesLocalDataSourceImpl(prefs);
    final repo = TvSeriesRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
    );
    return {
      'getPopular': GetPopularTvSeries(repo),
      'getTopRated': GetTopRatedTvSeries(repo),
      'getNowPlaying': GetNowPlayingTvSeries(repo),
      'search': SearchTvSeries(repo),
      'getDetail': GetTvSeriesDetail(repo),
      'getRecommendations': GetTvSeriesRecommendations(repo),
      'getWatchlist': GetWatchlist(repo),
      'addToWatchlist': AddToWatchlist(repo),
      'removeFromWatchlist': RemoveFromWatchlist(repo),
      'isAddedToWatchlist': IsAddedToWatchlist(repo),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _initDependencies(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final usecases = snapshot.data!;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => TvSeriesListCubit(
                getPopularTvSeries: usecases['getPopular'],
                getTopRatedTvSeries: usecases['getTopRated'],
                getNowPlayingTvSeries: usecases['getNowPlaying'],
                searchTvSeries: usecases['search'],
                getTvSeriesDetail: usecases['getDetail'],
                getTvSeriesRecommendations: usecases['getRecommendations'],
                getWatchlist: usecases['getWatchlist'],
                addToWatchlistUsecase: usecases['addToWatchlist'],
                removeFromWatchlistUsecase: usecases['removeFromWatchlist'],
                isAddedToWatchlistUsecase: usecases['isAddedToWatchlist'],
              ),
            ),
          ],
          child: MaterialApp(
            title: 'TV Series App',
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (_) => const TvSeriesHomePage(),
                  );
                case '/category':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => TvSeriesCategoryPage(
                      title: args['title'],
                      tvSeriesList: args['tvSeriesList'],
                    ),
                  );
                case '/detail':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => TvSeriesDetailPage(
                      detail: args['detail'],
                      recommendations: args['recommendations'],
                    ),
                  );
                case '/search':
                  return MaterialPageRoute(
                    builder: (_) => const TvSeriesSearchPage(),
                  );
                case '/watchlist':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => WatchlistPage(
                      watchlist: args['watchlist'],
                      onRemove: args['onRemove'],
                      onTapDetail: args['onTapDetail'],
                    ),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      body: Center(child: Text('Page not found')),
                    ),
                  );
              }
            },
          ),
        );
      },
    );
  }
}
