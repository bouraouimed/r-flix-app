import 'package:bloc/bloc.dart';

import '../model/movie.dart';
import '../repository/movie_respository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final TMDBMovieRepository _movieRepository;

  MovieBloc(this._movieRepository) : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMoviesEvent) {
      yield MovieLoadingState();
      try {
        final List<Movie> movies = await _movieRepository.getMovies();
        final List<Genre> genres = await _movieRepository.getCategoryNames();
        yield MovieLoadedState(movies, genres);
      } catch (e) {
        yield MovieErrorState('Failed to fetch movies');
      }
    } else if (event is NavigateToMovieDetailsEvent) {
      yield MovieLoadingState();
      try {
        final movie = await _movieRepository.getMovieDetails(event.movieId);
        final List<MovieReview> reviews =
            await _movieRepository.getMovieReviews(event.movieId);
        yield MovieDetailsScreenState(movie, reviews);
      } catch (e) {
        yield MovieErrorState('Failed to fetch movie details: $e');
      }
    }
  }
}
