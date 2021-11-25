import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class CinemaDao {
  static final CinemaDao _singleton = CinemaDao._internal();

  factory CinemaDao() => _singleton;

  CinemaDao._internal();

  /// save cinema to database
  void saveAllCinemaDayTimeSlot(
      List<CinemaDayTimeSlotVO> cinemaList, String date) async {
    List<CinemaDayTimeSlotVO> updatedCinemaList = cinemaList.map((cinema) {
      CinemaDayTimeSlotVO? cinemaFromHive = this.getCinemaById(cinema.cinemaId);
      if (cinemaFromHive == null) {
        return cinema;
      } else {
        cinemaFromHive.dates?.add(date);
        return cinemaFromHive;
      }
    }).toList();
    Map<int, CinemaDayTimeSlotVO> cinemaMap = Map.fromIterable(
        updatedCinemaList,
        key: (cinema) => cinema.cinemaId,
        value: (cinema) => cinema);
    await getCinemaDayTimeSlotBox().putAll(cinemaMap);
  }

  CinemaDayTimeSlotVO? getCinemaById(int cinemaId) {
    return getCinemaDayTimeSlotBox().get(cinemaId);
  }

  /// get from database
  List<CinemaDayTimeSlotVO> getAllCinemaDayTimeSlot(String date) {
    return getCinemaDayTimeSlotBox()
        .values
        .where((element) => element.dates?.contains(date) ?? false)
        .toList();
  }

  /// reactive programming
  Stream<void> getCinemaDayTimeSlotEventStream() {
    return getCinemaDayTimeSlotBox().watch();
  }

  Stream<List<CinemaDayTimeSlotVO>> getAllCinemaDayTimeSlotListStream(
      String date) {
    return Stream.value(getAllCinemaDayTimeSlot(date));
  }

  List<CinemaDayTimeSlotVO> getCinemaDayTimeSlotList(String date) {
    if (getAllCinemaDayTimeSlot(date).isNotEmpty) {
      return getAllCinemaDayTimeSlot(date);
    } else {
      return [];
    }
  }

  Box<CinemaDayTimeSlotVO> getCinemaDayTimeSlotBox() {
    return Hive.box(BOX_NAME_CINEMA_DAY_TIME_SLOT_VO);
  }
}
