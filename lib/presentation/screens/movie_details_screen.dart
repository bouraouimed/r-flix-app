import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:r_flix_app/presentation/screens/webview_screen.dart';

import '../../constants/constants.dart';
import '../../logic/bloc/movie_bloc.dart';
import '../../logic/bloc/movie_event.dart';
import '../../logic/bloc/movie_state.dart';
import '../../logic/model/movie.dart';
import '../../logic/repository/movie_respository.dart';
import '../widgets/rating.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  MovieDetailsScreen(this.movieId);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  Movie? _movie;
  late List<MovieReview> _reviews = <MovieReview>[];
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
    return BlocProvider(
      create: (context) => MovieBloc(TMDBMovieRepository())
        ..add(NavigateToMovieDetailsEvent(widget.movieId)),
      child: BlocListener<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieLoadingState) {
            setState(() {
              _isLoading = true;
              _errorMsg = '';
              _reviews = <MovieReview>[];
              _userRatedMovies = <RatedMovie>[];
            });
          } else if (state is MovieDetailsScreenState) {
            setState(() {
              _isLoading = false;
              _movie = state.movie;
              _reviews = state.reviews;
              _userRatedMovies = state.ratedMovies;
              _errorMsg = '';
            });
          } else if (state is MovieRatedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Movie ${state.movieId} rated to ${state.rate}')));
          } else if (state is MovieRateDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Movie rate ${state.movieId} deleted!')));
          } else if (state is MovieRatingErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Unable to rate movie ${state.movieId}')));
          }
        },
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            return _buildContent();
          },
        ),
      ),
    );
  }

  List<Widget>? _buildProductionCompanies(List<ProductionCompany>? companies) {
    return companies
        ?.map((company) => Text(
              '${company.name} (${company.originCountry})',
              style: TextStyle(fontSize: 16.0),
            ))
        .toList();
  }

  Widget _buildLink(String title, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyWebView(url: url, pageTitle: title)),
        );
      },
      // child: WebViewWidget(controller: controller),
      child: Text(
        '$title: $url',
        style: TextStyle(fontSize: 16.0, color: Colors.blue),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, MovieReview review) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Author: ${review.author}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Rating: ${review.authorDetails.rating}'),
            SizedBox(height: 8.0),
            Text(review.content),
          ],
        ),
      ),
    );
  }

  String _displayGenreNames(genres) {
    return genres.map((genre) => genre.name).join(', ');
  }

  Widget _buildContent() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Movie Details'),
        ),
        body: Stack(children: [
          _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
          _errorMsg.isNotEmpty
              ? Center(child: Text('Error: ${_errorMsg}'))
              : Container(),
          !_isLoading
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Your UI code here based on the Movie object
                      SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://image.tmdb.org/t/p/w500${_movie?.posterPath}',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Year of Release: ${DateTime.parse(_movie!.releaseDate).year}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Genres: ${_displayGenreNames(_movie!.genres)}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 8.0),
                            _buildLink('Homepage', _movie?.homepage ?? ''),
                            _buildLink('IMDb Page',
                                'https://www.imdb.com/title/${_movie?.imdbId ?? ''}'),
                            SizedBox(height: 16.0),
                            Text(
                              'Overview:',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              _movie?.overview ?? '',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Running Time: ${_movie?.runtime} minutes',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Production Companies:',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildProductionCompanies(
                                      _movie?.productionCompanies) ??
                                  [],
                            ),
                            SizedBox(height: 20.0),
                            MovieRating(
                                movie: _movie,
                                actionsExtend: false,
                                userRatedMovies: _userRatedMovies),
                            SizedBox(height: 16.0),
                            Text(
                              'Users reviews',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: _reviews.length > MAX_REVIEWS_COUNT
                                  ? MAX_REVIEWS_COUNT
                                  : _reviews.length,
                              itemBuilder: (context, index) {
                                return _buildReviewCard(
                                    context, _reviews[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator())
        ]));
  }
}
