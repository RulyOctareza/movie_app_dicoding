import 'package:flutter/material.dart';
import '../cubit/tv_series_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tv_series.dart';

class TvSeriesCategoryPage extends StatelessWidget {
  final String title;
  final List<TvSeries> tvSeriesList;

  const TvSeriesCategoryPage({
    super.key,
    required this.title,
    required this.tvSeriesList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181829),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181829),
        elevation: 0,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: tvSeriesList.length,
        itemBuilder: (context, index) {
          final tv = tvSeriesList[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              title: Text(tv.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                'Rating: ${tv.voteAverage}',
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () async {
                final cubit = context.read<TvSeriesListCubit>();
                final detail = await cubit.getDetail(tv.id);
                final recommendations = await cubit.getRecommendations(tv.id);
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
    );
  }
}
