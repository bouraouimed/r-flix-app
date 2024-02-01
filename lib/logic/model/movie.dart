class MovieResponse {
  final int page;
  final List<Movie> results;

  MovieResponse({
    required this.page,
    required this.results,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      page: json['page'],
      results: List<Movie>.from(
        json['results'].map((result) => Movie.fromJson(result)),
      ),
    );
  }
}

class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'],
      logoPath: json['logo_path'],
      name: json['name'],
      originCountry: json['origin_country'],
    );
  }
}

class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso31661: json['iso_3166_1'],
      name: json['name'],
    );
  }
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'],
      iso6391: json['iso_639_1'],
      name: json['name'],
    );
  }
}

class MovieCollection {
  final int id;
  final String name;
  final String posterPath;
  final String backdropPath;

  MovieCollection({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.backdropPath,
  });

  factory MovieCollection.fromJson(Map<String, dynamic> json) {
    return MovieCollection(
      id: json['id'],
      name: json['name'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
    );
  }
}

class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  final MovieCollection? belongsToCollection;
  final int? budget;
  final List<Genre>? genres;
  final String? homepage;
  final List<ProductionCompany>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final int? revenue;
  final int? runtime;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final String? tagline;
  final String? imdbId;

  Movie(
      {required this.adult,
      this.backdropPath,
      this.genreIds,
      required this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      required this.popularity,
      this.posterPath,
      required this.releaseDate,
      required this.title,
      required this.video,
      required this.voteAverage,
      required this.voteCount,
      this.belongsToCollection,
      this.budget,
      this.genres,
      this.homepage,
      this.productionCompanies,
      this.productionCountries,
      this.revenue,
      this.runtime,
      this.spokenLanguages,
      this.status,
      this.tagline,
      this.imdbId});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'],
      backdropPath: json['backdrop_path'] ?? '',
      genreIds:
          json['genre_ids'] != null ? List<int>.from(json['genre_ids']) : [],
      id: json['id'],
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: json['popularity'].toDouble(),
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      title: json['title'],
      video: json['video'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
      belongsToCollection: json['belongs_to_collection'] != null
          ? MovieCollection.fromJson(json['belongs_to_collection'])
          : null,
      budget: json['budget'] ?? 0,
      imdbId: json['imdb_id'] ?? '',
      genres: json['genres'] != null
          ? List<Genre>.from(
              json['genres'].map((genre) => Genre.fromJson(genre)))
          : null,
      homepage: json['homepage'] ?? '',
      productionCompanies: json['production_companies'] != null
          ? List<ProductionCompany>.from(
              json['production_companies']
                  .map((company) => ProductionCompany.fromJson(company)),
            )
          : null,
      productionCountries: json['production_countries'] != null
          ? List<ProductionCountry>.from(
              json['production_countries']
                  .map((country) => ProductionCountry.fromJson(country)),
            )
          : null,
      revenue: json['revenue'] ?? 0,
      runtime: json['runtime'] ?? 0,
      spokenLanguages: json['spoken_languages'] != null
          ? List<SpokenLanguage>.from(
              json['spoken_languages']
                  .map((language) => SpokenLanguage.fromJson(language)),
            )
          : null,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
    );
  }
}

class RatedMovie {
  final int id;
  final double rating;

  RatedMovie({
    required this.id,
    required this.rating,
  });

  factory RatedMovie.fromJson(Map<String, dynamic> json) {
    return RatedMovie(
      id: json['id'],
      rating: json['rating'],
    );
  }
}

class RatedMovieResponse {
  final List<RatedMovie> results;
  final int totalPages;
  final int totalResults;
  final int page;

  RatedMovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory RatedMovieResponse.fromJson(Map<String, dynamic> json) {
    return RatedMovieResponse(
      page: json['page'],
      results: List<RatedMovie>.from(
        json['results'].map((result) => RatedMovie.fromJson(result)),
      ),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

class GenreResponse {
  final List<Genre> results;

  GenreResponse({
    required this.results,
  });

  factory GenreResponse.fromJson(Map<String, dynamic> json) {
    return GenreResponse(
      results: List<Genre>.from(
        json['genres'].map((result) => Genre.fromJson(result)),
      ),
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  List<Object?> get props => [id, name];
}

class MovieReviewResponse {
  final int id;
  final int page;
  final List<MovieReview> results;
  final int totalPages;
  final int totalResults;

  MovieReviewResponse({
    required this.id,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieReviewResponse.fromJson(Map<String, dynamic> json) {
    return MovieReviewResponse(
      id: json['id'],
      page: json['page'],
      results: List<MovieReview>.from(
        json['results'].map((result) => MovieReview.fromJson(result)),
      ),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

class MovieReview {
  final String author;
  final AuthorDetails authorDetails;
  final String content;
  final String createdAt;
  final String id;
  final String updatedAt;
  final String url;

  MovieReview({
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.url,
  });

  factory MovieReview.fromJson(Map<String, dynamic> json) {
    return MovieReview(
      author: json['author'],
      authorDetails: AuthorDetails.fromJson(json['author_details']),
      content: json['content'],
      createdAt: json['created_at'],
      id: json['id'],
      updatedAt: json['updated_at'],
      url: json['url'],
    );
  }
}

class AuthorDetails {
  final String name;
  final String username;
  final String? avatarPath; // Nullable
  final double? rating;

  AuthorDetails({
    required this.name,
    required this.username,
    this.avatarPath,
    this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) {
    return AuthorDetails(
      name: json['name'],
      username: json['username'],
      avatarPath: json['avatar_path'],
      rating: json['rating'] ?? 0.toDouble(),
    );
  }
}

class MovieRatingResponse {
  bool? success;
  int status_code;
  String status_message;

  MovieRatingResponse(
      {this.success, required this.status_code, required this.status_message});

  factory MovieRatingResponse.fromJson(Map<String, dynamic> json) {
    return MovieRatingResponse(
        success: json['success'] ?? false,
        status_code: json['status_code'],
        status_message: json['status_message']);
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "status_code": status_code,
        "status_message": status_message,
      };

  List<Object?> get props => [success, status_code, status_message];
}
