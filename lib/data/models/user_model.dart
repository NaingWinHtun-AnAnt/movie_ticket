import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';

abstract class UserModel {
  /// from network
  void getUserProfile(String token);

  Future<List<TransactionVO>> getProfileTransaction(String token);

  /// from database
  Stream<UserVO?> getUserProfileFromDatabase(String token);
}
