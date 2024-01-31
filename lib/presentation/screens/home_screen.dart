import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_flix_app/presentation/screens/movie_details_screen.dart';

import '../../constants/constants.dart';
import '../../logic/bloc/movie_bloc.dart';
import '../../logic/bloc/movie_event.dart';
import '../../logic/bloc/movie_state.dart';
import '../../logic/model/movie.dart';
import '../../logic/repository/movie_respository.dart';
import '../widgets/rating.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Movie> _movies = <Movie>[];
  late List<Genre> _genres = <Genre>[];
  late List<RatedMovie> _userRatedMovies = <RatedMovie>[];

  bool _isLoading = true;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
      ),
      body: BlocProvider(
        create: (_) => MovieBloc(TMDBMovieRepository())
          ..add(
            FetchMoviesEvent(),
          ),
        child: BlocListener<MovieBloc, MovieState>(listener: (context, state) {
          if (state is MovieLoadingState) {
            _isLoading = true;
            _errorMsg = '';
            _movies = <Movie>[];
            _genres = <Genre>[];
            _userRatedMovies = <RatedMovie>[];
          } else if (state is MovieLoadedState) {
            setState(() {
              _isLoading = false;
              _errorMsg = '';
              _movies = state.movies;
              _genres = state.genres;
              _userRatedMovies = state.ratedMovies;
            });
          } else if (state is MovieRatedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Movie ${state.movieId} rated to ${state.rate}')));
          } else if (state is MovieRateDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Movie rate ${state.movieId} deleted!')));
          } else if (state is MovieErrorState) {
            setState(() {
              _errorMsg = state.error.toString();
            });
          } else if (state is MovieRatingErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Unable to rate movie')));
          }
        }, child: BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
          return _buildMovieList();
        })),
      ),
      // ),
    );
  }

  String _getGenreNames(List<int> genreIds, genres) {
    return genreIds
        .map((id) => genres
            .firstWhere((genre) => genre.id == id,
                orElse: () => Genre(id: -1, name: 'unknown'))
            .name)
        .toList()
        .join(', ');
  }

  Widget _buildMovieList() {
    // List<Movie> movies, List<Genre> genres
    return Stack(
      children: [
        ListView.builder(
          itemCount: this._movies.length > MAX_MOVIES_LENGTH
              ? MAX_MOVIES_LENGTH
              : this._movies.length,
          itemBuilder: (context, index) {
            final movie = this._movies[index];

            return Card(
              margin: EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(movie.id),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Poster
                    Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Movie Title
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Year of Release
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Release Year: ${movie.releaseDate.substring(0, 4)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    // Genres
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Genres: ${_getGenreNames(movie.genreIds ?? [], _genres)}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    MovieRating(
                      movie: movie,
                      actionsExtend: true,
                      userRatedMovies: _userRatedMovies,
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          },
        ),
        _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        _errorMsg.isNotEmpty
            ? Center(child: Text('Error: ${_errorMsg}'))
            : Container(),
      ],
    );
  }
}
