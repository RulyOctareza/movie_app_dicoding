import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../cubit/movie_list_cubit.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({super.key});

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  void _search(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final cubit = context.read<MovieListCubit>();
      final results = await cubit.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Search', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF232441),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.search, color: Colors.yellow),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search Movies',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _search,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _searchResults = []);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Search Result',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Center(
                child: Text(_error!, style: TextStyle(color: Colors.red)),
              ),
            if (!_isLoading && _error == null)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = _searchResults[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232441),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: movie.posterPath.isNotEmpty
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
                          movie.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Rating:  {movie.voteAverage}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () async {
                          final cubit = context.read<MovieListCubit>();
                          final detail = await cubit.fetchDetail(movie.id);
                          final recommendations = await cubit
                              .fetchRecommendations(movie.id);
                          if (context.mounted) {
                            Navigator.pushNamed(
                              context,
                              '/movie_detail',
                              arguments: {
                                'detail': detail,
                                'recommendations': recommendations,
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
