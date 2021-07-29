import 'package:movie_ticket/data/models/snack_model.dart';
import 'package:movie_ticket/data/vos/snack_vo.dart';
import 'package:movie_ticket/network/agents/movie_ticket_data_agent.dart';
import 'package:movie_ticket/network/agents/retrofit_data_agent_impl.dart';
import 'package:movie_ticket/persistence/daos/snack_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class SnackModelImpl extends SnackModel {
  MovieTicketDataAgent _mDataAgent = RetrofitDataAgentImpl();

  static final SnackModelImpl _singleton = SnackModelImpl._internal();

  factory SnackModelImpl() => _singleton;

  SnackModelImpl._internal();

  /// dao
  final _snackDao = SnackDao();

  @override
  void getSnacks(String token) {
    _mDataAgent.getSnacks(token).then((value) {
      List<SnackVO> _snackList = value.map((snack) {
        snack.count = 0;
        return snack;
      }).toList();
      _snackDao.saveAllSnacks(_snackList);
    });
  }

  /// from database
  @override
  void saveSelectedSnackToDatabase(SnackVO snack) {
    _snackDao.saveSelectedSnacks(snack);
  }

  @override
  Stream<List<SnackVO>> getAllSnacksFromDatabase(
    String token,
  ) {
    this.getSnacks(token);
    return _snackDao
        .getSnackListEventStream()
        .startWith(_snackDao.getSnackListStream())
        .map((event) => _snackDao.getSnackList());
  }

  @override
  Future<List<SnackVO>> getSelectedSnacksFromDatabase() {
    return Future.value(_snackDao.getSelectedSnacks());
  }
}
