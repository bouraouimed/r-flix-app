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
    if (event is FetchPopularMoviesEvent) {
      yield MovieLoadingState();
      try {
        final List<Movie> popularMovies = await _movieRepository.getPopularMovies();
        final List<RatedMovie> ratedMoviesIds = await _movieRepository.getRatedMoviesIds();

        final List<Genre> genres = await _movieRepository.getCategoryNames();
        yield PopularMoviesLoadedState(popularMovies, genres, ratedMoviesIds);
      } catch (e) {
        yield MovieErrorState('Failed to fetch movies');
      }
    } else if(event is FetchTopRatedMoviesEvent) {
      yield MovieLoadingState();
      try {
        final List<Movie> topRatedMovies = await _movieRepository.getTopRatedMovies();
        final List<RatedMovie> ratedMoviesIds = await _movieRepository.getRatedMoviesIds();

        final List<Genre> genres = await _movieRepository.getCategoryNames();
        yield TopRatedMoviesLoadedState(topRatedMovies, genres, ratedMoviesIds);
      } catch (e) {
        yield MovieErrorState('Failed to fetch movies');
      }
    }
    else if(event is FetchUserRatedMoviesEvent) {
      yield MovieLoadingState();
      try {
        final List<Movie> userRatedMovies = await _movieRepository.getUserRatedMovies();
        final List<RatedMovie> ratedMoviesIds = await _movieRepository.getRatedMoviesIds();

        final List<Genre> genres = await _movieRepository.getCategoryNames();
        yield UserRatedMoviesLoadedState(userRatedMovies, genres, ratedMoviesIds);
      } catch (e) {
        yield MovieErrorState('Failed to fetch movies');
      }
    }
    else if (event is NavigateToMovieDetailsEvent) {
      yield MovieLoadingState();
      try {
        final movie = await _movieRepository.getMovieDetails(event.movieId);
        final List<RatedMovie> ratedMovies = await _movieRepository.getRatedMoviesIds();
        final List<MovieReview> reviews =
            await _movieRepository.getMovieReviews(event.movieId);
        yield MovieDetailsScreenState(movie, reviews, ratedMovies);
      } catch (e) {
        yield MovieErrorState('Failed to fetch movie details: $e');
      }
    } else if (event is RateMovieEvent) {
      try {
            await _movieRepository.rateMovie(event.movieId, event.rate);
            yield MovieRatedState(event.movieId, event.rate);
      } catch (e) {
        yield MovieRatingErrorState(
            event.movieId, 'Failed to rate movie details: $e');
      }
    } else if (event is DeleteRateMovieEvent) {
      try {
        await _movieRepository.deleteMovieRate(event.movieId);
        yield MovieRateDeletedState(event.movieId);
      } catch (e) {
        yield MovieRatingErrorState(
            event.movieId, 'Failed to rate movie details: $e');
      }
    } else if (event is SearchTextChanged){
      final List<Movie> searchResults = await _movieRepository.searchMovies(event.query.toString());
      final List<RatedMovie> ratedMoviesIds = await _movieRepository.getRatedMoviesIds();

      final List<Genre> genres = await _movieRepository.getCategoryNames();

      final suggestions = searchResults
          .map((movie) => movie.title)
          .toSet().toList();

      yield MovieSearchState(suggestions, searchResults, genres, ratedMoviesIds);

    }
  }
}
