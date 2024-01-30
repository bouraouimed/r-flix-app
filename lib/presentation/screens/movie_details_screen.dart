import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../logic/bloc/movie_bloc.dart';
import '../../logic/bloc/movie_event.dart';
import '../../logic/bloc/movie_state.dart';
import '../../logic/model/movie.dart';
import '../../logic/repository/movie_respository.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  MovieDetailsScreen(this.movieId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(TMDBMovieRepository()),
      child: MovieDetailsScreenContent(movieId),
    );
  }
}

class MovieDetailsScreenContent extends StatelessWidget {
  final int movieId;

  MovieDetailsScreenContent(this.movieId);

  @override
  Widget build(BuildContext context) {
    final movieDetailsBloc = BlocProvider.of<MovieBloc>(context);

    // Trigger the loading of movie details when the screen is first built
    movieDetailsBloc.add(NavigateToMovieDetailsEvent(movieId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailsScreenState) {
            return _buildContent(state.movie, state.reviews);
          } else if (state is MovieErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Container(); // You can customize this case based on your needs
          }
        },
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
    //   WebViewController controller = WebViewController()
    //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //     ..setBackgroundColor(const Color(0x00000000))
    //     ..setNavigationDelegate(
    //       NavigationDelegate(
    //         onProgress: (int progress) {
    //           // Update loading bar.
    //         },
    //         onPageStarted: (String url) {},
    //         onPageFinished: (String url) {},
    //         onWebResourceError: (WebResourceError error) {},
    //         onNavigationRequest: (NavigationRequest request) {
    //           return NavigationDecision.navigate;
    //         },
    //       ),
    //     )
    //     ..loadRequest(Uri.parse(url.toString()));

    return GestureDetector(
      onTap: () {},
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

  Widget _buildContent(Movie movie, List<MovieReview> reviews) {
    return SingleChildScrollView(
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
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Year of Release: ${DateTime.parse(movie.releaseDate).year}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                // Text(
                //   'Genres: ${_getGenresString(movie.genres)}',
                //   style: TextStyle(fontSize: 16.0),
                // ),
                // SizedBox(height: 8.0),
                _buildLink('Homepage', movie.homepage ?? ''),
                _buildLink(
                    'IMDb Page', 'https://www.imdb.com/title/${movie.id}'),
                SizedBox(height: 16.0),
                Text(
                  'Overview:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  movie.overview,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Running Time: ${movie.runtime} minutes',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Production Companies:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _buildProductionCompanies(movie.productionCompanies) ??
                          [],
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: reviews.length > MAX_REVIEWS_COUNT
                      ? MAX_REVIEWS_COUNT
                      : reviews.length,
                  itemBuilder: (context, index) {
                    return _buildReviewCard(context, reviews[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
