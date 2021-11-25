import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class SeatDao {
  static final SeatDao _singleton = SeatDao._internal();

  factory SeatDao() => _singleton;

  SeatDao._internal();

  /// save to database
  void saveAllMovieSeat(List<MovieSeatVO> seatList) async {
    Map<String, MovieSeatVO> _seatMap = Map.fromIterable(
      seatList,
      key: (seat) => "${seat.id}_${seat.title}",
      value: (seat) => seat,
    );
    await getMovieSeatBox().putAll(_seatMap);
  }

  /// get from database
  List<MovieSeatVO> getAllSeats() {
    return getMovieSeatBox().values.toList();
  }

  Box<MovieSeatVO> getMovieSeatBox() {
    return Hive.box(BOX_NAME_MOVIE_SEAT_VO);
  }
}
