import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/data/vos/cinema_vo.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';

abstract class CinemaModel {
  /// from network
  Future<List<CinemaVO>?>? getCinemaList();

  Future<List<MovieSeatVO>?>? getSeatPlan(
    String token,
    int id,
    String bookingDate,
  );

  void getCinemaDayTimeSlots(
    String token,
    String date,
  );

  /// from database
  Stream<List<CinemaDayTimeSlotVO>> getCinemaDayTimeSlotsFromDatabase(
    String token,
    String date,
  );

  Future<List<MovieSeatVO>> getAllMovieSeatFromDatabase();
}
