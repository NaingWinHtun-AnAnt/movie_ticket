import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class SeatDao {
  static final SeatDao _singleton = SeatDao._internal();

  factory SeatDao() => _singleton;

  SeatDao._internal();

  void saveSelectedSeat(MovieSeatVO seat) async {
    seat.isSelected!
        ? await getSelectedMovieSeatBox().put(seat.seatName, seat)
        : getSelectedMovieSeatBox().delete(seat.seatName);
  }

  void saveAllMovieSeat(List<MovieSeatVO> seatList) async {
    Map<String, MovieSeatVO> _seatMap = Map.fromIterable(
      seatList,
      key: (seat) => "${seat.id}_${seat.title}",
      value: (seat) => seat,
    );
    await getMovieSeatBox().clear();
    await getMovieSeatBox().putAll(_seatMap);
  }

  List<MovieSeatVO> getSelectedSeat() {
    return getSelectedMovieSeatBox().values.toList();
  }

  List<MovieSeatVO> getAllSeats() {
    return getMovieSeatBox().values.toList();
  }

  void clearSelectedSeatBox() {
    getSelectedMovieSeatBox().clear();
  }

  Box<MovieSeatVO> getMovieSeatBox() {
    return Hive.box(BOX_NAME_MOVIE_SEAT_VO);
  }

  Box<MovieSeatVO> getSelectedMovieSeatBox() {
    return Hive.box(BOX_NAME_SELECTED_MOVIE_SEAT);
  }
}
