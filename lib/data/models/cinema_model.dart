import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/data/vos/cinema_vo.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';

abstract class CinemaModel {
  /// from network
  Future<List<CinemaVO>> getCinemaList();

  Future<List<MovieSeatVO>> getSeatPlan(
    String token,
    int id,
    String bookingDate,
  );

  Future<List<CinemaDayTimeSlotVO>> getCinemaDayTimeSlots(
    String token,
    String date,
  );

  /// from database
  void saveSelectedCinemaDayTimeSlotsToDatabase(
    CinemaDayTimeSlotVO cinema,
  );

  Future<List<CinemaDayTimeSlotVO>> getCinemaDayTimeSlotsFromDatabase(
    String date,
  );

  Future<CinemaDayTimeSlotVO> getSelectedCinemaDayTimeSlotsFromDatabase();

  void saveSelectedSeatToDatabase(MovieSeatVO seat);

  Future<List<MovieSeatVO>> getAllMovieSeatFromDatabase();

  Future<List<MovieSeatVO>> getSelectedMovieSeatFromDatabase();
}
