import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tv_series.dart';
import '../cubit/tv_series_list_cubit.dart';

class TvSeriesSearchPage extends StatefulWidget {
  const TvSeriesSearchPage({super.key});

  @override
  State<TvSeriesSearchPage> createState() => _TvSeriesSearchPageState();
}

class _TvSeriesSearchPageState extends State<TvSeriesSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<TvSeries> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  void _search(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final cubit = context.read<TvSeriesListCubit>();
      // Anda perlu menambahkan usecase dan method search di cubit
      final results = await cubit.search(query);
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
                        hintText: 'Search TV Series',
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
                    final tv = _searchResults[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF232441),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: tv.posterPath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w92${tv.posterPath}',
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.tv, color: Colors.white),
                        title: Text(
                          tv.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Rating: ${tv.voteAverage}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () async {
                          // Navigasi ke halaman detail TV Series
                          final cubit = context.read<TvSeriesListCubit>();
                          final detail = await cubit.getDetail(tv.id);
                          final recommendations = await cubit
                              .getRecommendations(tv.id);
                          if (context.mounted) {
                            Navigator.pushNamed(
                              context,
                              '/detail',
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
