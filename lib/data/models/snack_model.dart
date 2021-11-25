import 'package:movie_ticket/data/vos/snack_vo.dart';

abstract class SnackModel {
  /// from network
  void getSnacks(String token);

  /// from database
  Stream<List<SnackVO>> getAllSnacksFromDatabase(String token,);
}
