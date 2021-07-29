import 'package:hive/hive.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

class PaymentMethodDao {
  static final PaymentMethodDao _singleton = PaymentMethodDao._internal();

  factory PaymentMethodDao() => _singleton;

  PaymentMethodDao._internal();

  /// save to database
  void saveAllPaymentMethods(List<PaymentMethodVO> paymentMethods) async {
    Map<int, PaymentMethodVO> paymentMethodMap = Map.fromIterable(
      paymentMethods,
      key: (paymentMethod) => paymentMethod.id,
      value: (paymentMethod) => paymentMethod,
    );
    await getPaymentMethodBox().putAll(paymentMethodMap);
  }

  /// get from database
  List<PaymentMethodVO> getAllPaymentMethods() {
    return getPaymentMethodBox().values.toList();
  }

  /// reactive programming set up
  Stream<void> getPaymentEventStream() {
    return getPaymentMethodBox().watch();
  }

  Stream<List<PaymentMethodVO>> getPaymentListStream() {
    return Stream.value(getAllPaymentMethods());
  }

  List<PaymentMethodVO> getPaymentList() {
    if (getAllPaymentMethods().isNotEmpty) {
      return getAllPaymentMethods();
    } else {
      return [];
    }
  }

  Box<PaymentMethodVO> getPaymentMethodBox() {
    return Hive.box(BOX_NAME_PAYMENT_METHOD_VO);
  }
}
