import 'package:movie_ticket/data/models/user_model.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';
import 'package:movie_ticket/network/agents/movie_ticket_data_agent.dart';
import 'package:movie_ticket/network/agents/retrofit_data_agent_impl.dart';
import 'package:movie_ticket/persistence/daos/user_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class UserModelImpl extends UserModel {
  final MovieTicketDataAgent _mDataAgent = RetrofitDataAgentImpl();

  static final UserModelImpl _singleton = UserModelImpl._internal();

  factory UserModelImpl() => _singleton;

  UserModelImpl._internal();

  /// dao
  final UserDao _userDao = UserDao();

  /// from network
  @override
  void getUserProfile(String token) {
    _mDataAgent.getUserProfile(token);
  }

  @override
  Future<List<TransactionVO>> getProfileTransaction(String token) {
    return _mDataAgent.getProfileTransaction(token);
  }

  /// from database
  @override
  Stream<UserVO?> getUserProfileFromDatabase(String token) {
    this.getUserProfile(token);
    return _userDao
        .getUserEventStream()
        .startWith(_userDao.getUserStream())
        .map((event) => _userDao.getUserFirstTime());
  }
}
