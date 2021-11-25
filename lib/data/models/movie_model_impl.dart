import 'package:movie_ticket/data/models/movie_model.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/network/agents/movie_ticket_data_agent.dart';
import 'package:movie_ticket/network/agents/retrofit_data_agent_impl.dart';
import 'package:movie_ticket/network/api_constants.dart';
import 'package:movie_ticket/persistence/daos/movie_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class MovieModelImpl extends MovieModel {
  final MovieTicketDataAgent _mDataAgent = RetrofitDataAgentImpl();

  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl() => _singleton;

  MovieModelImpl._internal();

  /// dao
  MovieDao _movieDao = MovieDao();

  /// from network
  @override
  void getNowPlayingMovieList() {
    _mDataAgent.getMovieList(NOW_SHOWING)?.then((movies) {
      final List<MovieVO> _nowPlayingMovies = movies?.map((movie) {
            movie.isNowPlaying = true;
            return movie;
          }).toList() ??
          [];
      _movieDao.saveMovieList(_nowPlayingMovies);
    });
  }

  @override
  void getComingSoonMovieList() {
    _mDataAgent.getMovieList(COMING_SOON)?.then((movies) {
      final List<MovieVO> _comingSoonMovies = movies?.map((movie) {
            movie.isComingSoon = true;
            return movie;
          }).toList() ??
          [];
      _movieDao.saveMovieList(_comingSoonMovies);
    });
  }

  @override
  void getMovieDetailById(int movieId) {
    _mDataAgent.getMovieDetailById(movieId)?.then((value) {
      if (value != null) _movieDao.saveMovieVO(value);
    });
  }

  /// from database
  @override
  Stream<List<MovieVO>> getNowPlayingMovieListFromDatabase() {
    this.getNowPlayingMovieList();
    return _movieDao
        .getMovieEventStream()
        .startWith(_movieDao.getNowPlayingMovieListStream())
        .map((event) => _movieDao.getNowShowingMovieList());
  }

  @override
  Stream<List<MovieVO>> getComingSoonMovieListFromDatabase() {
    this.getComingSoonMovieList();
    return _movieDao
        .getMovieEventStream()
        .startWith(_movieDao.getComingSoonMovieListStream())
        .map((event) => _movieDao.getComingSoonMovieList());
  }

  @override
  Stream<MovieVO?> getMovieDetailFromDatabase(int movieId) {
    this.getMovieDetailById(movieId);
    return _movieDao
        .getMovieEventStream()
        .startWith(_movieDao.getMovieDetailByIdStream())
        .map((event) => _movieDao.getMovieDetailFirstTime());
  }
}
