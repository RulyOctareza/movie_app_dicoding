import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_series.dart';

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
  final List<TvSeries> watchlist;

  TvSeriesListLoaded({
    required this.popular,
    required this.topRated,
    required this.nowPlaying,
    required this.watchlist,
  });

  @override
  List<Object?> get props => [popular, topRated, nowPlaying, watchlist];
}

class TvSeriesWatchlistLoaded extends TvSeriesListState {
  final List<TvSeries> watchlist;
  TvSeriesWatchlistLoaded(this.watchlist);
  @override
  List<Object?> get props => [watchlist];
}

class TvSeriesListError extends TvSeriesListState {
  final String message;
  TvSeriesListError(this.message);
  @override
  List<Object?> get props => [message];
}
