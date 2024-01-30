const String APP_TITLE = "Discover Movies";

const String EMAIL_LABEL = 'Email';

const String PASSWORD_LABEL = 'Password';

const String LOGIN_LABEL = 'Login';

const String TMDB_BASE_URL = 'https://api.themoviedb.org/3';

// login API calls
const String TMDB_LOGIN_API_URL =
    '$TMDB_BASE_URL/authentication/token/validate_with_login';

const String TMDB_LOGIN_REQUEST_TOKEN =
    '5af8e3830c24af17cdbfdc89e831ba3536c58240';

const String TMDB_LOGIN_AUTHORIZATION_TOKEN =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZGU1NzYzYmE4OTIyNGUwODJlM2I1MGJhNTAzZmYzZCIsInN1YiI6IjY1OWQ3N2ZhNzc3NmYwMDE0ODI5NWZiMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qxM3IBBcrmUPJ6wIdZvOqUAsD9mUFRBknjhDBLYLjDo';

// list movies categories API
const String GET_MOVIES_GENRES_API =
    'https://api.themoviedb.org/3/genre/movie/list?language=en';

// list movies API
const String GET_FAVORITE_MOVIES_URL =
    '$TMDB_BASE_URL/movie/popular?language=en-US&page=1';

// movie details
const String GET_MOVIE_DETAILS_URL = '$TMDB_BASE_URL/movie/%ID?language=en-US';

// movie reviews
const String GET_MOVIE_REVIEWS_URL =
    '$TMDB_BASE_URL/movie/%ID/reviews?language=en-US&page=1';

// Max number of reviews to be displayed
const int MAX_REVIEWS_COUNT = 5;

// Number of items to display in the movies list
const int MAX_MOVIES_LENGTH = 40 ;