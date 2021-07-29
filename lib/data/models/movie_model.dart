import 'package:movie_ticket/data/vos/movie_vo.dart';

abstract class MovieModel {
  /// from network
  void getNowPlayingMovieList();

  void getComingSoonMovieList();

  void getMovieDetailById(int movieId);

  /// from database
  Stream<List<MovieVO>?> getNowPlayingMovieListFromDatabase();

  Stream<List<MovieVO>?> getComingSoonMovieListFromDatabase();

  Future<MovieVO?> getMovieDetailFromDatabase(int movieId);

  Future<int> getSelectedMovieIdFromDatabase();
}
