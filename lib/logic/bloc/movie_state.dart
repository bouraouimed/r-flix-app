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
  List<RatedMovie> ratedMovies;

  MovieLoadedState(this.movies, this.genres, this.ratedMovies);

  @override
  List<Object?> get props => [movies, genres, ratedMovies];
}

class MovieDetailsScreenState extends MovieState {
  final Movie movie;
  final List<MovieReview> reviews;
  List<RatedMovie> ratedMovies;

  MovieDetailsScreenState(this.movie, this.reviews, this.ratedMovies);
}

class MovieRatedState extends MovieState {
  final int movieId;
  final double rate;

  MovieRatedState(this.movieId, this.rate);
}

class MovieRateDeletedState extends MovieState {
  final int movieId;

  MovieRateDeletedState(this.movieId);
}


class MovieRatingErrorState extends MovieState {
  final String error;
  final int movieId;

  MovieRatingErrorState(this.movieId, this.error);

  @override
  List<Object?> get props => [error];
}

class MovieErrorState extends MovieState {
  final String error;

  MovieErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
