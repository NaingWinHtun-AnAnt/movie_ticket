import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/data/models/payment_model.dart';
import 'package:movie_ticket/data/models/payment_model_impl.dart';
import 'package:movie_ticket/data/models/snack_model.dart';
import 'package:movie_ticket/data/models/snack_model_impl.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';
import 'package:movie_ticket/data/vos/snack_vo.dart';
import 'package:movie_ticket/pages/payment_detail_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';
import 'package:movie_ticket/widgets/back_button_view.dart';
import 'package:movie_ticket/widgets/text_field_view.dart';
import 'package:movie_ticket/widgets/title_text.dart';

class TicketsAndPaymentPage extends StatefulWidget {
  final double ticketTotalPrice;

  const TicketsAndPaymentPage({
    required this.ticketTotalPrice,
  });

  @override
  State<TicketsAndPaymentPage> createState() => _TicketsAndPaymentPageState();
}

class _TicketsAndPaymentPageState extends State<TicketsAndPaymentPage> {
  final PaymentModel _mMovieTicketModel = PaymentModelImpl();
  final SnackModel _mSnackModel = SnackModelImpl();
  final AuthenticationModel _mAuthModel = AuthenticationModelImpl();
  List<SnackVO>? _mSnackList;
  List<PaymentMethodVO>? _mPaymentMethodList;
  double _subTotal = 0.0;

  @override
  void initState() {
    /// from database
    _mSnackModel
        .getAllSnacksFromDatabase(_mAuthModel.getTokenFromDatabase()!)
        .listen((value) {
      setState(() {
        _mSnackList = value;
      });
    });

    _mMovieTicketModel
        .getAllPaymentMethodsFromDatabase(_mAuthModel.getTokenFromDatabase()!)
        .listen((value) {
      setState(() {
        _mPaymentMethodList = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mSnackList == null || _mPaymentMethodList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackButtonView(
                      Icons.chevron_left,
                      () => Navigator.pop(context),
                    ),
                    SizedBox(
                      height: MARGIN_MEDIUM_2,
                    ),
                    Container(
                      child: SnackSectionView(
                        snackList: _mSnackList!,
                        onTapDecreaseControl: (snackId, value) =>
                            _decreaseSnackCount(snackId, value),
                        onTapIncreaseControl: (snackId, value) =>
                            _increaseSnackCount(snackId, value),
                      ),
                      height: TICKET_TYPE_HEIGHT,
                    ),
                    SizedBox(
                      height: MARGIN_MEDIUM_2,
                    ),
                    PromoCodeSectionView(),
                    SizedBox(
                      height: MARGIN_MEDIUM_2,
                    ),
                    SubTotalTextView(
                      subTotal: widget.ticketTotalPrice + _subTotal,
                    ),
                    SizedBox(
                      height: MARGIN_LARGE,
                    ),
                    PaymentSectionView(
                      paymentList: _mPaymentMethodList!,
                    ),
                    SizedBox(
                      height: MARGIN_XXLARGE,
                    ),
                    PaymentButtonView(
                      totalAmount: widget.ticketTotalPrice + _subTotal,
                      onTapPaymentButton: () =>
                          _navigateToPaymentDetailPage(context),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _decreaseSnackCount(int snackId, int value) {
    setState(() {
      _mSnackList!.where((element) => element.id == snackId).first.count =
          value;
    });

    _calculateSubTotal(snackId, value, true);
  }

  void _increaseSnackCount(int snackId, int value) {
    setState(() {
      _mSnackList!.where((element) => element.id == snackId).first.count =
          value;
    });

    _calculateSubTotal(snackId, value, false);
  }

  void _calculateSubTotal(int snackId, int value, bool des) {
    /// save selected snack with count
    _mSnackModel.saveSelectedSnackToDatabase(
        _mSnackList!.where((element) => element.id == snackId).first);

    setState(() {
      des
          ? _subTotal -= _mSnackList!
              .where((element) => element.id == snackId)
              .first
              .price!
          : _subTotal += _mSnackList!
              .where((element) => element.id == snackId)
              .first
              .price!;
    });
  }

  void _navigateToPaymentDetailPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaymentDetailPage(
          paymentAmount: widget.ticketTotalPrice + _subTotal,
        ),
      ),
    );
  }
}

class PaymentButtonView extends StatelessWidget {
  final double totalAmount;
  final Function onTapPaymentButton;

  PaymentButtonView({
    required this.totalAmount,
    required this.onTapPaymentButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
        bottom: MARGIN_XLARGE,
      ),
      child: LongButtonView(
        "Pay \$$totalAmount",
        PRIMARY_COLOR,
        () => onTapPaymentButton(),
      ),
    );
  }
}

class PaymentSectionView extends StatelessWidget {
  final List<PaymentMethodVO> paymentList;

  const PaymentSectionView({required this.paymentList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            PAYMENT_TEXT,
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          Visibility(
            visible: paymentList.length != 0,
            child: PaymentListView(
              paymentMethod: paymentList,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentListView extends StatelessWidget {
  final List<PaymentMethodVO> paymentMethod;

  const PaymentListView({
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentView(
          Icons.credit_card,
          paymentMethod[0].name,
          paymentMethod[0].description,
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        PaymentView(
          Icons.credit_card,
          paymentMethod[0].name,
          paymentMethod[0].description,
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        PaymentView(
          Icons.account_balance_wallet,
          paymentMethod[0].name,
          paymentMethod[0].description,
        ),
      ],
    );
  }
}

class PaymentView extends StatelessWidget {
  final IconData icon;
  final String cardType;
  final String cardSample;

  PaymentView(
    this.icon,
    this.cardType,
    this.cardSample,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PAYMENT_ICON_COLOR,
        ),
        SizedBox(
          width: MARGIN_MEDIUM_2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardType,
              style: TextStyle(
                color: TITLE_TEXT_COLOR,
                fontSize: TEXT_REGULAR_2X,
              ),
            ),
            SizedBox(
              height: MARGIN_SMALL,
            ),
            Text(
              cardSample,
              style: TextStyle(
                color: TICKET_INFO_LABEL_TEXT_COLOR,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SubTotalTextView extends StatelessWidget {
  final double subTotal;

  const SubTotalTextView({required this.subTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Text(
        "Sub total : $subTotal\$",
        style: TextStyle(
          fontSize: TEXT_REGULAR_2X,
          color: ADD_NEW_CARD_BUTTON_AND_TEXT_COLOR,
        ),
      ),
    );
  }
}

class PromoCodeSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Column(
        children: [
          TextFieldView(
            labelText: PROMO_CODE_TEXT,
            hintText: PROMO_CODE_SAMPLE_TEXT,
            controller: TextEditingController(),
            italicLabel: true,
          ),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          Row(
            children: [
              Text(
                DO_NOT_HAVE_PROMO_CODE_TEXT,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: MARGIN_SMALL,
              ),
              Text(
                GET_IT_NOW_TEXT,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SnackSectionView extends StatelessWidget {
  final List<SnackVO> snackList;
  final Function(int, int) onTapDecreaseControl;
  final Function(int, int) onTapIncreaseControl;

  const SnackSectionView(
      {required this.snackList,
      required this.onTapDecreaseControl,
      required this.onTapIncreaseControl});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: snackList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) => ComBoSetView(
        snack: snackList[index],
        onTapDecreaseControl: (snackId, value) =>
            onTapDecreaseControl(snackId, value),
        onTapIncreaseControl: (snackId, value) =>
            onTapIncreaseControl(snackId, value),
      ),
    );
  }
}

class ComBoSetView extends StatelessWidget {
  final SnackVO snack;
  final Function(int, int) onTapDecreaseControl;
  final Function(int, int) onTapIncreaseControl;

  ComBoSetView(
      {required this.snack,
      required this.onTapDecreaseControl,
      required this.onTapIncreaseControl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
        bottom: MARGIN_MEDIUM_2,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ComboSetNameAndInfoSectionView(
              snack.name!,
              snack.description!,
            ),
          ),
          Spacer(),
          Expanded(
              flex: 1,
              child: PriceAndControlSectionView(
                snack: snack,
                onTapDecreaseControl: (snackId, value) =>
                    onTapDecreaseControl(snackId, value),
                onTapIncreaseControl: (snackId, value) =>
                    onTapIncreaseControl(snackId, value),
              )),
        ],
      ),
    );
  }
}

class ComboSetNameAndInfoSectionView extends StatelessWidget {
  const ComboSetNameAndInfoSectionView(
    this.comboSetName,
    this.comboSetDetail,
  );

  final String comboSetName;
  final String comboSetDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comboSetName,
          style: TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: TITLE_TEXT_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: MARGIN_SMALL,
        ),
        Text(
          comboSetDetail,
          style: TextStyle(
            color: TICKET_INFO_LABEL_TEXT_COLOR,
          ),
        ),
      ],
    );
  }
}

class PriceAndControlSectionView extends StatelessWidget {
  final SnackVO snack;
  final Function(int, int) onTapDecreaseControl;
  final Function(int, int) onTapIncreaseControl;

  const PriceAndControlSectionView({
    required this.snack,
    required this.onTapDecreaseControl,
    required this.onTapIncreaseControl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PriceTextView(
          price: "${snack.price}",
        ),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        PriceControlView(
          snack: snack,
          onTapDecreaseControl: (snackId, value) =>
              onTapDecreaseControl(snackId, value),
          onTapIncreaseControl: (snackId, value) =>
              onTapIncreaseControl(snackId, value),
        ),
      ],
    );
  }
}

class PriceTextView extends StatelessWidget {
  final String price;

  PriceTextView({
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "$price\$",
      style: TextStyle(
        fontSize: TEXT_REGULAR_2X,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class PriceControlView extends StatelessWidget {
  final SnackVO snack;
  final Function(int, int) onTapDecreaseControl;
  final Function(int, int) onTapIncreaseControl;

  const PriceControlView(
      {required this.snack,
      required this.onTapDecreaseControl,
      required this.onTapIncreaseControl});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ControlButtonView(
            icon: Icons.remove,
            snack: snack,
            onTapControlButton: (snackId, value) =>
                onTapDecreaseControl(snackId, value <= 0 ? 0 : --value),
          ),
          TicketCounterTextView(
            snackCounter: snack.count!,
          ),
          ControlButtonView(
            icon: Icons.add,
            snack: snack,
            onTapControlButton: (snackId, value) =>
                onTapIncreaseControl(snackId, ++value),
          ),
        ],
      ),
    );
  }
}

class ControlButtonView extends StatelessWidget {
  final IconData icon;
  final SnackVO snack;
  final Function(int, int) onTapControlButton;

  ControlButtonView({
    required this.snack,
    required this.icon,
    required this.onTapControlButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapControlButton(snack.id, snack.count!),
      child: Container(
        padding: EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class TicketCounterTextView extends StatelessWidget {
  final int snackCounter;

  const TicketCounterTextView({required this.snackCounter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM,
      ),
      child: Center(
        child: Text(snackCounter.toString()),
      ),
    );
  }
}
