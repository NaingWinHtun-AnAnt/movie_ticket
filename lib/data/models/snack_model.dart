import 'package:movie_ticket/data/vos/snack_vo.dart';

abstract class SnackModel {
  /// from network
  void getSnacks(String token);

  /// from database
  void saveSelectedSnackToDatabase(SnackVO snack);

  Stream<List<SnackVO>> getAllSnacksFromDatabase(String token,);

  Future<List<SnackVO>> getSelectedSnacksFromDatabase();
}
