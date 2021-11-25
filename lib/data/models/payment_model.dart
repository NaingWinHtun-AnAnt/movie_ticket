import 'package:movie_ticket/network/requests/check_out_request.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/network/responses/create_card_response.dart';

abstract class PaymentModel {
  /// from network
  Future<CreateCardResponse?>? createCard(String token, String cardNumber,
      String cardHolder, String expirationDate, String cvc);

  void getPaymentMethod(String token);

  Future<TransactionVO?>? checkOut(String token, CheckOutRequest transaction);

  /// from database
  Stream<List<PaymentMethodVO>> getAllPaymentMethodsFromDatabase(String token);

  Future<TransactionVO> getTransactionVOByIdFromDatabase(int transactionId);
}
