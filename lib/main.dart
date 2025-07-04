import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'common/ssl_pinning.dart';

import 'data/datasources/tv_series_local_data_source.dart';
import 'data/datasources/tv_series_remote_data_source.dart';
import 'data/repositories/tv_series_repository_impl.dart';
import 'domain/usecases/get_season_episodes.dart';
import 'domain/usecases/tv_series_usecases.dart';
import 'presentation/cubit/tv_series_list_cubit.dart';
import 'presentation/pages/tv_series_category_page.dart';
import 'presentation/pages/tv_series_detail_page.dart';
import 'presentation/pages/tv_series_home_page.dart';
import 'presentation/pages/tv_series_search_page.dart';
import 'presentation/pages/watchlist_page.dart';
import 'presentation/pages/movie_home_page.dart';
import 'presentation/pages/movie_category_page.dart';
import 'presentation/pages/movie_detail_page.dart';
import 'presentation/pages/movie_search_page.dart';
import 'presentation/pages/movie_watchlist_page.dart';
import 'data/datasources/movie_remote_data_source.dart';
import 'data/datasources/movie_local_data_source.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/usecases/movie_usecases.dart';
import 'presentation/cubit/movie_list_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<Map<String, dynamic>> _initDependencies() async {
    final client = await SslPinning.createPinnedClient();
    final prefs = await SharedPreferences.getInstance();
    // Load API key from .env
    final apiKey = dotenv.env['api_key'] ?? '2174d146bb9c0eab47529b2e77d6b526';
    final remote = TvSeriesRemoteDataSourceImpl(client: client, apiKey: apiKey);
    final local = TvSeriesLocalDataSourceImpl(prefs);
    final repo = TvSeriesRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
    );
    // Movie dependencies
    final movieRemote = MovieRemoteDataSourceImpl(
      client: client,
      apiKey: apiKey,
    );
    final movieLocal = MovieLocalDataSourceImpl(prefs);
    final movieRepo = MovieRepositoryImpl(
      remoteDataSource: movieRemote,
      localDataSource: movieLocal,
    );
    return {
      // TV Series usecases
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
      'getSeasonEpisodes': GetSeasonEpisodes(repo),
      // Movie usecases
      'getPopularMovie': GetPopularMovies(movieRepo),
      'getTopRatedMovie': GetTopRatedMovies(movieRepo),
      'getNowPlayingMovie': GetNowPlayingMovies(movieRepo),
      'searchMovie': SearchMovies(movieRepo),
      'getMovieDetail': GetMovieDetail(movieRepo),
      'getMovieRecommendations': GetMovieRecommendations(movieRepo),
      'getMovieWatchlist': GetMovieWatchlist(movieRepo),
      'addMovieToWatchlist': AddMovieToWatchlist(movieRepo),
      'removeMovieFromWatchlist': RemoveMovieFromWatchlist(movieRepo),
      'isMovieAddedToWatchlist': IsMovieAddedToWatchlist(movieRepo),
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
                getSeasonEpisodesUsecase: usecases['getSeasonEpisodes'],
              )..fetchAll(),
            ),
            BlocProvider(
              create: (_) => MovieListCubit(
                getPopularMovies: usecases['getPopularMovie'],
                getTopRatedMovies: usecases['getTopRatedMovie'],
                getNowPlayingMovies: usecases['getNowPlayingMovie'],
                searchMovies: usecases['searchMovie'],
                getMovieDetail: usecases['getMovieDetail'],
                getMovieRecommendations: usecases['getMovieRecommendations'],
                getWatchlist: usecases['getMovieWatchlist'],
                addToWatchlistUsecase: usecases['addMovieToWatchlist'],
                removeFromWatchlistUsecase:
                    usecases['removeMovieFromWatchlist'],
                isAddedToWatchlistUsecase: usecases['isMovieAddedToWatchlist'],
              )..fetchAll(),
            ),
          ],
          child: MaterialApp(
            title: 'Movie & TV Series App',
            home: const MainTabBarPage(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (_) => const MainTabBarPage(),
                  );
                case '/movie':
                  return MaterialPageRoute(
                    builder: (_) => const MovieHomePage(),
                  );
                case '/movie_category':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => MovieCategoryPage(
                      title: args['title'],
                      movies: args['movies'],
                    ),
                  );
                case '/movie_detail':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => MovieDetailPage(
                      detail: args['detail'],
                      recommendations: args['recommendations'],
                    ),
                  );
                case '/movie_search':
                  return MaterialPageRoute(
                    builder: (_) => const MovieSearchPage(),
                  );
                case '/movie_watchlist':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => MovieWatchlistPage(
                      watchlist: args['watchlist'],
                      onRemove: args['onRemove'] as Future<void> Function(int),
                      onTapDetail:
                          args['onTapDetail'] as Future<void> Function(int),
                    ),
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

class MainTabBarPage extends StatefulWidget {
  const MainTabBarPage({super.key});

  @override
  State<MainTabBarPage> createState() => _MainTabBarPageState();
}

class _MainTabBarPageState extends State<MainTabBarPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        title: const Text('Ditonton', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Movies',

              icon: Icon(Icons.movie, color: Colors.white),
            ),
            Tab(
              text: 'TV Series',
              icon: Icon(Icons.tv, color: Colors.white),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [MovieHomePage(), const TvSeriesHomePage()],
      ),
    );
  }
}
