import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class CinemaDao {
  static final CinemaDao _singleton = CinemaDao._internal();

  factory CinemaDao() => _singleton;

  CinemaDao._internal();

  void saveSelectedCinemaDayTimeSlot(CinemaDayTimeSlotVO cinema) async {
    await getCinemaDayTimeSlotBox().put(cinema.cinemaId, cinema);
  }

  // void saveCinemas(List<CinemaDayTimeSlotVO> cinemaList, String date) async {
  //   List<CinemaDayTimeSlotVO> updatedCinemaList = cinemaList.map((cinema) {
  //     CinemaDayTimeSlotVO? cinemaFromHive = this.getCinemaById(cinema.cinemaId);
  //     if (cinemaFromHive == null) {
  //       return cinema;
  //     } else {
  //       cinemaFromHive.dates.add(date);
  //       return cinemaFromHive;
  //     }
  //   }).toList();
  //   Map<int, CinemaDayTimeSlotVO> cinemaMap = Map.fromIterable(
  //       updatedCinemaList,
  //       key: (cinema) => cinema.cinemaId,
  //       value: (cinema) => cinema);
  //   await getCinemaDayTimeSlotBox().putAll(cinemaMap);
  // }
  //
  // CinemaDayTimeSlotVO? getCinemaById(int cinemaId) {
  //   return getCinemaDayTimeSlotBox().get(cinemaId);
  // }

  void saveAllCinemaDayTimeSlot(List<CinemaDayTimeSlotVO> cinemaList) async {
    Map<int, CinemaDayTimeSlotVO> _cinemaMap = Map.fromIterable(
      cinemaList,
      key: (cinema) => cinema.cinemaId,
      value: (cinema) => cinema,
    );
    await getCinemaDayTimeSlotBox().putAll(_cinemaMap);
  }

  CinemaDayTimeSlotVO? getSelectedCinemaDayTimeSlot() {
    return getCinemaDayTimeSlotBox()
        .values
        .where((element) => element.isSelected == true)
        .first;
  }

  List<CinemaDayTimeSlotVO> getAllCinemaDayTimeSlot(String date) {
    return getCinemaDayTimeSlotBox()
        .values
        .where((element) => element.bookingDate == date)
        .toList();
  }

  Box<CinemaDayTimeSlotVO> getCinemaDayTimeSlotBox() {
    return Hive.box(BOX_NAME_CINEMA_DAY_TIME_SLOT_VO);
  }
}
