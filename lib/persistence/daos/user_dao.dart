import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class UserDao {
  static final UserDao _singleton = UserDao._internal();

  factory UserDao() => _singleton;

  UserDao._internal();

  void saveUserVO(UserVO? user) async {
    if (user != null) await getUserBox().put(HIVE_USER_KEY, user);
  }

  UserVO? getUser() {
    return getUserBox().get(HIVE_USER_KEY);
  }

  /// reactive programming
  Stream<void> getUserEventStream() {
    return getUserBox().watch();
  }

  Stream<UserVO> getUserStream() {
    return Stream.value(getUser()!);
  }

  UserVO? getUserFirstTime() {
    if (getUser() != null) {
      return getUser();
    } else {
      return null;
    }
  }

  Box<UserVO> getUserBox() {
    return Hive.box(BOX_NAME_USER_VO);
  }
}
