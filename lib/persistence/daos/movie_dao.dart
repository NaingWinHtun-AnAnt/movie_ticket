import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class MovieDao {
  static final MovieDao _singleton = MovieDao._internal();

  factory MovieDao() => _singleton;

  MovieDao._internal();

  void saveMovieList(List<MovieVO> movieList) async {
    Map<int, MovieVO> _movieListMap = Map.fromIterable(
      movieList,
      key: (movie) => movie.id,
      value: (movie) => movie,
    );
    await getMovieBox().putAll(_movieListMap);
  }

  void saveMovieVO(MovieVO movie) async {
    await getMovieIdBox().put(MOVIE_ID, movie.id);
    await getMovieBox().put(movie.id, movie);
  }

  List<MovieVO> getMovieList() {
    return getMovieBox().values.toList();
  }

  MovieVO getMovieDetailById(int movieId) {
    return getMovieBox().get(movieId)!;
  }

  int getMovieId() {
    return getMovieIdBox().get(MOVIE_ID)!;
  }

  /// reactive programming
  Stream<void> getMovieEventStream() {
    return getMovieBox().watch();
  }

  Stream<List<MovieVO>> getNowPlayingMovieListStream() {
    return Stream.value(
      getMovieList().where((element) => element.isNowPlaying == true).toList(),
    );
  }

  Stream<List<MovieVO>> getComingSoonMovieListStream() {
    return Stream.value(
      getMovieList().where((element) => element.isComingSoon == true).toList(),
    );
  }

  Stream<MovieVO> getMovieDetailByIdStream(int movieId) {
    return Stream.value(
      getMovieDetailById(movieId),
    );
  }

  /// issue - data will be null if first time login
  List<MovieVO> getNowShowingMovieList() {
    if (getMovieList().isNotEmpty) {
      return getMovieList()
          .where((element) => element.isNowPlaying == true)
          .toList();
    } else {
      return [];
    }
  }

  List<MovieVO> getComingSoonMovieList() {
    if (getMovieList().isNotEmpty) {
      return getMovieList()
          .where((element) => element.isComingSoon == true)
          .toList();
    } else {
      return [];
    }
  }

  Box<MovieVO> getMovieBox() {
    return Hive.box(BOX_NAME_MOVIE_VO);
  }

  Box<int> getMovieIdBox() {
    return Hive.box(BOX_NAME_MOVIE_ID);
  }
}
