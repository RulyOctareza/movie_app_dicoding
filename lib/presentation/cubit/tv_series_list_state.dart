part of 'tv_series_list_cubit.dart';

abstract class TvSeriesListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvSeriesListInitial extends TvSeriesListState {}
class TvSeriesListLoading extends TvSeriesListState {}
class TvSeriesListLoaded extends TvSeriesListState {
  final List<TvSeries> popular;
  final List<TvSeries> topRated;
  final List<TvSeries> nowPlaying;

  TvSeriesListLoaded({
    required this.popular,
    required this.topRated,
    required this.nowPlaying,
  });

  @override
  List<Object?> get props => [popular, topRated, nowPlaying];
}
class TvSeriesListError extends TvSeriesListState {
  final String message;
  TvSeriesListError(this.message);
  @override
  List<Object?> get props => [message];
}
 