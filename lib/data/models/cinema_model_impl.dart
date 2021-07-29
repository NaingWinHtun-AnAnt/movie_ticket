import 'package:movie_ticket/data/models/cinema_model.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/data/vos/cinema_vo.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';
import 'package:movie_ticket/network/agents/movie_ticket_data_agent.dart';
import 'package:movie_ticket/network/agents/retrofit_data_agent_impl.dart';
import 'package:movie_ticket/persistence/daos/cinema_dao.dart';
import 'package:movie_ticket/persistence/daos/seat_dao.dart';

class CinemaModelImpl extends CinemaModel {
  MovieTicketDataAgent _mDataAgent = RetrofitDataAgentImpl();

  static final CinemaModelImpl _singleton = CinemaModelImpl._internal();

  factory CinemaModelImpl() => _singleton;

  CinemaModelImpl._internal();

  ///dao
  final _cinemaDao = CinemaDao();
  final _seatDao = SeatDao();

  @override
  Future<List<CinemaVO>> getCinemaList() {
    return _mDataAgent.getCinemaList();
  }

  @override
  Future<List<MovieSeatVO>> getSeatPlan(
    String token,
    int id,
    String bookingDate,
  ) {
    return _mDataAgent.getSeatPlan(token, id, bookingDate).then((value) {
      List<MovieSeatVO> _seatList = [];
      value.forEach((element) {
        _seatList.addAll(element);
      });
      _seatDao.saveAllMovieSeat(_seatList);
      return Future.value(_seatList);
    });
  }

  @override
  Future<List<CinemaDayTimeSlotVO>> getCinemaDayTimeSlots(
    String token,
    String date,
  ) {
    return _mDataAgent.getCinemaDayTimeSlots(token, date).then((value) {
      List<CinemaDayTimeSlotVO> cinemaTimeSlot = value.map((cinemaDayTimeSlot) {
        cinemaDayTimeSlot.bookingDate = date;
        return cinemaDayTimeSlot;
      }).toList();

      _cinemaDao.saveAllCinemaDayTimeSlot(cinemaTimeSlot);

      return Future.value(cinemaTimeSlot);
    });
  }

  /// from database
  @override
  void saveSelectedCinemaDayTimeSlotsToDatabase(CinemaDayTimeSlotVO cinema) {
    _cinemaDao.saveSelectedCinemaDayTimeSlot(cinema);
  }

  @override
  Future<List<CinemaDayTimeSlotVO>> getCinemaDayTimeSlotsFromDatabase(
    String date,
  ) {
    return Future.value(_cinemaDao.getAllCinemaDayTimeSlot(date));
  }

  @override
  Future<CinemaDayTimeSlotVO> getSelectedCinemaDayTimeSlotsFromDatabase() {
    return Future.value(_cinemaDao.getSelectedCinemaDayTimeSlot());
  }

  @override
  void saveSelectedSeatToDatabase(MovieSeatVO seat) {
    _seatDao.saveSelectedSeat(seat);
  }

  @override
  Future<List<MovieSeatVO>> getSelectedMovieSeatFromDatabase() {
    return Future.value(_seatDao.getSelectedSeat());
  }

  @override
  Future<List<MovieSeatVO>> getAllMovieSeatFromDatabase() {
    return Future.value(_seatDao.getAllSeats());
  }
}
