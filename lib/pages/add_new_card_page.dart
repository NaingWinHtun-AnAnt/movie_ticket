import 'package:flutter/material.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/data/models/payment_model.dart';
import 'package:movie_ticket/data/models/payment_model_impl.dart';
import 'package:movie_ticket/data/models/user_model.dart';
import 'package:movie_ticket/data/models/user_model_impl.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/utility_functions.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';
import 'package:movie_ticket/widgets/add_new_card_view.dart';
import 'package:movie_ticket/widgets/back_button_view.dart';

class AddNewCardPage extends StatefulWidget {
  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final PaymentModel _mMovieTicketModel = PaymentModelImpl();
  final AuthenticationModel _mAuthModel = AuthenticationModelImpl();
  final UserModel _mUserModel = UserModelImpl();
  final _cardNumber = TextEditingController();
  final _cardHolder = TextEditingController();
  final _expireDate = TextEditingController();
  final _cvc = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumber.dispose();
    _cardHolder.dispose();
    _expireDate.dispose();
    _cvc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonView(
              Icons.chevron_left,
              () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: MARGIN_MEDIUM_2,
            ),
            AddNewCardView(
              cardNumberController: _cardNumber,
              cardHolderController: _cardHolder,
              expireDateController: _expireDate,
              cvcController: _cvc,
            ),
            Spacer(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(
                MARGIN_MEDIUM_2,
              ),
              child: LongButtonView(
                CONFIRM_BUTTON_TEXT,
                PRIMARY_COLOR,
                () => _createNewCard(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createNewCard(BuildContext context) {
    if (_formKey.currentState!.validate())
      _mMovieTicketModel
          .createCard(
        _mAuthModel.getTokenFromDatabase(),
        _cardNumber.text,
        _cardHolder.text,
        _expireDate.text,
        _cvc.text,
      )
          ?.then(
        (createCardResponse) {
          if (createCardResponse?.code == 200) {
            _mUserModel.getUserProfileFromDatabase(
              _mAuthModel.getTokenFromDatabase(),
            );
            Navigator.of(context).pop();
          }
        },
      ).catchError((error) {
        handleError(context: context, error: error);
      });
  }
}
