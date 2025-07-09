import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_dicoding/presentation/cubit/movie_list_cubit.dart';
import '../../domain/entities/movie.dart';

class RouteObserverProvider {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class MovieWatchlistPage extends StatefulWidget {
  const MovieWatchlistPage({
    super.key,
    required watchlist,
    required Future<void> Function(int p1) onRemove,
    required Future<void> Function(int p1) onTapDetail,
  });

  @override
  State<MovieWatchlistPage> createState() => _MovieWatchlistPageState();
}

class _MovieWatchlistPageState extends State<MovieWatchlistPage>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteObserverProvider.routeObserver.subscribe(
      this,
      ModalRoute.of(context) as PageRoute,
    );
    // Fetch watchlist saat halaman pertama kali dibuka
    context.read<MovieListCubit>().fetchAndEmitWatchlist();
  }

  @override
  void dispose() {
    RouteObserverProvider.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Fetch ulang watchlist saat kembali ke halaman ini
    context.read<MovieListCubit>().fetchAndEmitWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        title: const Text(
          'Movie Watchlist',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<MovieListCubit, MovieListState>(
        builder: (context, state) {
          List<Movie> watchlist = [];
          if (state is MovieListLoaded) {
            watchlist = state.watchlist;
          } else if (state is MovieWatchlistLoaded) {
            watchlist = state.movies;
          }
          if (state is MovieListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieListLoaded ||
              state is MovieWatchlistLoaded) {
            if (watchlist.isEmpty) {
              return const Center(
                child: Text(
                  'No movies in watchlist',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: watchlist.length,
              itemBuilder: (context, index) {
                final movie = watchlist[index];
                return Card(
                  color: const Color(0xFF232441),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: movie.posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          )
                        : const Icon(Icons.movie, color: Colors.white),
                    title: Text(
                      movie.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      movie.releaseDate,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await context
                            .read<MovieListCubit>()
                            .removeFromWatchlist(movie.id);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from Watchlist'),
                          ),
                        );
                      },
                    ),
                    onTap: () async {
                      final cubit = context.read<MovieListCubit>();
                      final recommendations = await cubit.fetchRecommendations(
                        movie.id,
                      );
                      if (!context.mounted) return;
                      Navigator.pushNamed(
                        context,
                        '/movie_detail',
                        arguments: {
                          'detail': movie,
                          'recommendations': recommendations,
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is MovieListError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
