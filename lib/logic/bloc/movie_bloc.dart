import 'package:bloc/bloc.dart';

import '../model/movie.dart';
import '../repository/movie_respository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final TMDBMovieRepository movieRepository;

  MovieBloc(this.movieRepository) : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMoviesEvent) {
      yield MovieLoadingState();
      try {
        final List<Movie> movies = await movieRepository.getMovies();
        final List<Genre> genres = await movieRepository.getCategoryNames();
        yield MovieLoadedState(movies, genres);
      } catch (e) {
        yield MovieErrorState('Failed to fetch movies');
      }
    }
  }
}
