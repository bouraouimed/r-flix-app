abstract class MovieEvent {
  const MovieEvent();
}

class FetchMoviesEvent extends MovieEvent {
  List<Object?> get props => [];
}

class NavigateToMovieDetailsEvent extends MovieEvent {
  final int movieId;

  NavigateToMovieDetailsEvent(this.movieId);
}
