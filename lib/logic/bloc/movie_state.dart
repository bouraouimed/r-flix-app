import 'package:equatable/equatable.dart';

import '../model/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitialState extends MovieState {}

class MovieLoadingState extends MovieState {}

class PopularMoviesLoadedState extends MovieState {
  final List<Movie> popularMovies;
  final List<Genre> genres;
  final List<RatedMovie> ratedMovies;

  const PopularMoviesLoadedState(
      this.popularMovies, this.genres, this.ratedMovies);

  @override
  List<Object?> get props => [popularMovies, genres, ratedMovies];
}

class TopRatedMoviesLoadedState extends MovieState {
  final List<Movie> topRatedMovies;
  final List<Genre> genres;
  final List<RatedMovie> ratedMovies;

  const TopRatedMoviesLoadedState(
      this.topRatedMovies, this.genres, this.ratedMovies);

  @override
  List<Object?> get props => [topRatedMovies, genres, ratedMovies];
}


class MovieDetailsScreenState extends MovieState {
  final Movie movie;
  final List<MovieReview> reviews;
  List<RatedMovie> ratedMovies;

  MovieDetailsScreenState(this.movie, this.reviews, this.ratedMovies);

  @override
  List<Object?> get props => [movie, reviews, ratedMovies];

}

class MovieRatedState extends MovieState {
  final int movieId;
  final double rate;

  MovieRatedState(this.movieId, this.rate);

  @override
  List<Object?> get props => [movieId, rate];

}

class MovieRateDeletedState extends MovieState {
  final int movieId;

  MovieRateDeletedState(this.movieId);

  @override
  List<Object?> get props => [movieId];

}

class MovieRatingErrorState extends MovieState {
  final String error;
  final int movieId;

  MovieRatingErrorState(this.movieId, this.error);

  @override
  List<Object?> get props => [error, movieId];
}

class MovieErrorState extends MovieState {
  final String error;

  MovieErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
