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
  late List<String> _searchSuggestions = <String>[];

  late List<RatedMovie> _userRatedMoviesIds = <RatedMovie>[];

  bool _isLoading = true;
  String _errorMsg = '';
  late String _selectedButton = 'Popular'; // Default selected button

  late TextEditingController? _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController?.dispose();
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
            FetchPopularMoviesEvent(),
          ),
        child: BlocListener<MovieBloc, MovieState>(listener: (context, state) {
          if (state is MovieLoadingState) {
            _isLoading = true;
            _errorMsg = '';
            _movies = <Movie>[];
            _genres = <Genre>[];
            _userRatedMoviesIds = <RatedMovie>[];
          } else if (state is PopularMoviesLoadedState) {
            setState(() {
              _isLoading = false;
              _errorMsg = '';
              _movies = state.popularMovies;
              _genres = state.genres;
              _userRatedMoviesIds = state.UserRatedMoviesIds;
            });
          } else if (state is TopRatedMoviesLoadedState) {
            setState(() {
              _isLoading = false;
              _errorMsg = '';
              _movies = state.topRatedMovies;
              _genres = state.genres;
              _userRatedMoviesIds = state.UserRatedMoviesIds;
            });
          } else if (state is UserRatedMoviesLoadedState) {
            setState(() {
              _isLoading = false;
              _errorMsg = '';
              _movies = state.userRatedMovies;
              _genres = state.genres;
              _userRatedMoviesIds = state.UserRatedMoviesIds;
            });
          } else if (state is MovieSearchState) {
            setState(() {
              _isLoading = false;
              _errorMsg = '';
              _movies = state.searchResults;
              _searchSuggestions = state.suggestions;
              _genres = state.genres;
              _userRatedMoviesIds = state.UserRatedMoviesIds;
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
          return Column(
            children: [
              _buildButtonsRow(context),
              _buildSearchBar(context),
              Expanded(
                child: _buildMovieList(),
              ),
            ],
          );
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

  Widget _buildButtonsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton('Popular', context),
          _buildButton('Top-Rated', context),
          _buildButton('My Ratings', context),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText, BuildContext context) {
    final movieBloc = BlocProvider.of<MovieBloc>(context);

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedButton = buttonText;
        });

        // Fetch data based on the selected button
        if (_selectedButton == 'Popular') {
          movieBloc.add(FetchPopularMoviesEvent());
        } else if (_selectedButton == 'Top-Rated') {
          movieBloc.add(FetchTopRatedMoviesEvent());
        } else if (_selectedButton == 'My Ratings') {
          movieBloc.add(FetchUserRatedMoviesEvent());
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedButton == buttonText ? Colors.amber : null,
      ),
      child: Text(buttonText),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final movieBloc = BlocProvider.of<MovieBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        TextField(
          controller: _searchController,
          onChanged: (query) {
            if(query.isNotEmpty) {
              movieBloc.add(SearchTextChanged(query));
            }
          },
          decoration: InputDecoration(
            labelText: 'Search for movies...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        _searchSuggestions.isEmpty
            ? Container()
            : DropdownButton<String>(
                isExpanded: true,
                value: _searchSuggestions.first,
                items: _searchSuggestions.map((movieTitle) {
                  return DropdownMenuItem<String>(
                    value: movieTitle,
                    child: Text(movieTitle),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _searchController?.text = value!;
                    if (_searchController!.text.isNotEmpty) {
                      movieBloc.add(SearchTextChanged(value!));
                    }
                  });
                },
                hint: Text('Select a movie'),
              )
      ]),
    );
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
                      userRatedMovies: _userRatedMoviesIds,
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
