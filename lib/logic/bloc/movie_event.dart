abstract class MovieEvent {
  const MovieEvent();
}

class FetchPopularMoviesEvent extends MovieEvent {
  List<Object?> get props => [];
}

class FetchTopRatedMoviesEvent extends MovieEvent {
  List<Object?> get props => [];
}


class NavigateToMovieDetailsEvent extends MovieEvent {
  final int movieId;

  NavigateToMovieDetailsEvent(this.movieId);
}

class RateMovieEvent extends MovieEvent {
  final int movieId;
  final double rate;

  RateMovieEvent(this.movieId, this.rate);
}

class DeleteRateMovieEvent extends MovieEvent {
  final int movieId;

  DeleteRateMovieEvent(this.movieId);
}



