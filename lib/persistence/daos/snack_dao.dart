import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/snack_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class SnackDao {
  static final SnackDao _singleton = SnackDao._internal();

  factory SnackDao() => _singleton;

  SnackDao._internal();

  void saveAllSnacks(List<SnackVO> snacks) async {
    Map<int, SnackVO> snackMap = Map.fromIterable(
      snacks,
      key: (snack) => snack.id,
      value: (snack) => snack,
    );
    await getSnackBox().putAll(snackMap);
  }

  void saveSelectedSnacks(SnackVO snack) async {
    snack.count! > 0
        ? await getSelectedSnackBox().put(snack.id, snack)
        : getSelectedSnackBox().delete(snack.id);
  }

  List<SnackVO> getAllSnacks() {
    return getSnackBox().values.toList();
  }

  List<SnackVO> getSelectedSnacks() {
    return getSelectedSnackBox().values.toList();
  }

  /// reactive programming
  Stream<void> getSnackListEventStream() {
    return getSnackBox().watch();
  }

  Stream<List<SnackVO>> getSnackListStream() {
    return Stream.value(getAllSnacks());
  }

  /// first time null value issue
  List<SnackVO> getSnackList() {
    if (getAllSnacks().isNotEmpty) {
      return getAllSnacks();
    } else {
      return [];
    }
  }

  Box<SnackVO> getSnackBox() {
    return Hive.box(BOX_NAME_SNACK_VO);
  }

  void clearSelectedSnackBox() {
    getSelectedSnackBox().clear();
  }

  Box<SnackVO> getSelectedSnackBox() {
    return Hive.box(BOX_NAME_SELECTED_SNACK);
  }
}
