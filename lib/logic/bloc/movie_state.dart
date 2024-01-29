import 'package:equatable/equatable.dart';

import '../model/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitialState extends MovieState {}

class MovieLoadingState extends MovieState {}

class MovieLoadedState extends MovieState {
  final List<Movie> movies;
  final List<Genre> genres;

  MovieLoadedState(this.movies, this.genres);

  @override
  List<Object?> get props => [movies, genres];
}

class MovieErrorState extends MovieState {
  final String error;

  MovieErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
