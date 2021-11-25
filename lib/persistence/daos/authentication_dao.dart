import 'package:hive/hive.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';
import 'package:flinq/flinq.dart';

class AuthenticationDao {
  static final AuthenticationDao _singleton = AuthenticationDao._internal();

  factory AuthenticationDao() => _singleton;

  AuthenticationDao._internal();

  void saveToken(String? token) async {
    if (token != null) await getTokenBox().add("Bearer " + token);
  }

  String? getToken() {
    return getTokenBox().values.firstOrNull;
  }

  void clear() {
    getTokenBox().clear();
  }

  Box<String> getTokenBox() {
    return Hive.box(BOX_NAME_TOKEN);
  }
}
