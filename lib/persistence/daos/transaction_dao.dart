import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class TransactionDao {
  static final TransactionDao _singleton = TransactionDao._internal();

  factory TransactionDao() => _singleton;

  TransactionDao._internal();

  void saveSingleTransactionVO(TransactionVO? transaction) {
    if (transaction != null)
      getTransactionBox().put(transaction.id, transaction);
  }

  TransactionVO? getTransactionVOById(int transactionId) {
    return getTransactionBox().get(transactionId);
  }

  Box<TransactionVO> getTransactionBox() {
    return Hive.box(BOX_NAME_TRANSACTION_VO);
  }
}
