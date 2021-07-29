import 'package:movie_ticket/data/models/payment_model.dart';
import 'package:movie_ticket/network/requests/check_out_request.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/network/agents/movie_ticket_data_agent.dart';
import 'package:movie_ticket/network/agents/retrofit_data_agent_impl.dart';
import 'package:movie_ticket/network/responses/create_card_response.dart';
import 'package:movie_ticket/persistence/daos/payment_dao.dart';
import 'package:movie_ticket/persistence/daos/seat_dao.dart';
import 'package:movie_ticket/persistence/daos/snack_dao.dart';
import 'package:movie_ticket/persistence/daos/transaction_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class PaymentModelImpl extends PaymentModel {
  MovieTicketDataAgent _mDataAgent = RetrofitDataAgentImpl();

  static final PaymentModelImpl _singleton = PaymentModelImpl._internal();

  factory PaymentModelImpl() => _singleton;

  PaymentModelImpl._internal();

  /// dao
  final _paymentMethodDao = PaymentMethodDao();
  final _transactionDao = TransactionDao();
  final _snackDao = SnackDao();
  final _seatDao = SeatDao();

  /// auth api
  @override
  Future<CreateCardResponse> createCard(
    String token,
    String cardNumber,
    String cardHolder,
    String expirationDate,
    String cvc,
  ) {
    return _mDataAgent.createCard(
        token, cardNumber, cardHolder, expirationDate, cvc);
  }

  @override
  void getPaymentMethod(String token) {
    _mDataAgent.getPaymentMethod(token).then((value) {
      _paymentMethodDao.saveAllPaymentMethods(value);
    });
  }

  @override
  Future<TransactionVO?> checkOut(String token, CheckOutRequest transaction) {
    return _mDataAgent.checkOut(token, transaction).then((value) {
      _transactionDao.saveSingleTransactionVO(value!);
      return Future.value(value);
    });
  }

  /// from database
  @override
  Stream<List<PaymentMethodVO>> getAllPaymentMethodsFromDatabase(String token) {
    this.getPaymentMethod(token);
    return _paymentMethodDao
        .getPaymentEventStream()
        .startWith(_paymentMethodDao.getPaymentListStream())
        .map((event) => _paymentMethodDao.getPaymentList());
  }

  @override
  Future<TransactionVO> getTransactionVOByIdFromDatabase(int transactionId) {
    return Future.value(_transactionDao.getTransactionVOById(transactionId));
  }

  @override
  void clearSelectedInDatabase() {
    _snackDao.clearSelectedSnackBox();
    _seatDao.clearSelectedSeatBox();
  }
}
