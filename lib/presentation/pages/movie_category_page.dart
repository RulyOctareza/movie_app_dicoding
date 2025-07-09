import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_dicoding/presentation/cubit/movie_list_cubit.dart';

class MovieCategoryPage extends StatelessWidget {
  final String title;
  final List movies;
  const MovieCategoryPage({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: movies.isEmpty
          ? const Center(
              child: Text(
                'No movies found',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232441),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading:
                        movie.posterPath != null && movie.posterPath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.movie, color: Colors.white),
                    title: Text(
                      movie.title ?? '-',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Rating: ${movie.voteAverage}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () async {
                      final cubit = context.read<MovieListCubit>();
                      final recommendations = await cubit.fetchRecommendations(
                        movie.id,
                      );
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
            ),
    );
  }
}
