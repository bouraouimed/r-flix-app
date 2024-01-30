import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert';

import '../../constants/constants.dart';
import '../model/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();

  Future<List<Genre>> getCategoryNames();

  Future<Movie> getMovieDetails(int id);
}

class TMDBMovieRepository implements MovieRepository {
  TMDBMovieRepository();

  @override
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(
        Uri.parse(GET_FAVORITE_MOVIES_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $TMDB_LOGIN_AUTHORIZATION_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final MovieResponse movieResponse = MovieResponse.fromJson(data);
        return movieResponse.results;
      } else {
        // Handle error
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<Genre>> getCategoryNames() async {
    try {
      final response = await http.get(
        Uri.parse(GET_MOVIES_GENRES_API),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $TMDB_LOGIN_AUTHORIZATION_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final GenreResponse genreResponse = GenreResponse.fromJson(data);
        return genreResponse.results;
      } else {
        // Handle error
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Error: $e');
    }
  }

  @override
  Future<Movie> getMovieDetails(int id) async {
    final String get_movie_details_url =
        GET_MOVIE_DETAILS_URL.replaceAll('%ID', id.toString());

    try {
      final response = await http.get(
        Uri.parse(get_movie_details_url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $TMDB_LOGIN_AUTHORIZATION_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        // Handle error
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Error: $e');
    }
  }

  Future<List<MovieReview>> getMovieReviews(int movieId) async {
    final String get_movie_reviewws_url =
        GET_MOVIE_REVIEWS_URL.replaceAll('%ID', movieId.toString());
    try {
      final response = await http.get(
        Uri.parse(get_movie_reviewws_url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $TMDB_LOGIN_AUTHORIZATION_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        return MovieReviewResponse.fromJson(jsonData).results;
      } else {
        // Handle error
        throw Exception('Failed to load movie reviews');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Error: $e');
    }

  }
}