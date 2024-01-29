import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/movie_bloc.dart';
import '../../logic/bloc/movie_event.dart';
import '../../logic/bloc/movie_state.dart';
import '../../logic/model/movie.dart';
import '../../logic/repository/movie_respository.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = MovieBloc(TMDBMovieRepository());
    _movieBloc.add(FetchMoviesEvent());
  }

  @override
  void dispose() {
    _movieBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
      ),
      body: BlocProvider(
        create: (_) => _movieBloc,
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            Widget content;
            if (state is MovieLoadingState) {
              content = Center(child: CircularProgressIndicator());
            } else if (state is MovieLoadedState) {
              content = _buildMovieList(state.movies, state.genres);
            } else if (state is MovieErrorState) {
              content = Center(child: Text('Error: ${state.error}'));
            } else {
              content = Container();
            }
            return content;
          },
        ),
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

  Widget _buildMovieList(List<Movie> movies, List<Genre> genres) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        return Card(
          margin: EdgeInsets.all(8.0),
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
                  'Genres: ${_getGenreNames(movie.genreIds, genres)}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
