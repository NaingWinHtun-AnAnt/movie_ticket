import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/data/models/cinema_model.dart';
import 'package:movie_ticket/data/models/cinema_model_impl.dart';
import 'package:movie_ticket/data/models/movie_model.dart';
import 'package:movie_ticket/data/models/movie_model_impl.dart';
import 'package:movie_ticket/data/models/payment_model.dart';
import 'package:movie_ticket/data/models/payment_model_impl.dart';
import 'package:movie_ticket/data/models/snack_model.dart';
import 'package:movie_ticket/data/models/snack_model_impl.dart';
import 'package:movie_ticket/data/models/user_model.dart';
import 'package:movie_ticket/data/models/user_model_impl.dart';
import 'package:movie_ticket/data/vos/card_vo.dart';
import 'package:movie_ticket/network/requests/check_out_request.dart';
import 'package:movie_ticket/network/requests/snack_request.dart';
import 'package:movie_ticket/pages/add_new_card_page.dart';
import 'package:movie_ticket/pages/ticket_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/utility_functions.dart';
import 'package:movie_ticket/viewitems/credit_card_view.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';
import 'package:movie_ticket/widgets/add_new_card_view.dart';
import 'package:movie_ticket/widgets/back_button_view.dart';
import 'package:movie_ticket/widgets/label_text_view.dart';

class PaymentDetailPage extends StatefulWidget {
  final double paymentAmount;

  const PaymentDetailPage({required this.paymentAmount});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  final AuthenticationModel _mAuthModel = AuthenticationModelImpl();
  final UserModel _mUserModel = UserModelImpl();
  final PaymentModel _mPaymentModel = PaymentModelImpl();
  final CinemaModel _mCinemaModel = CinemaModelImpl();
  final MovieModel _mMovieModel = MovieModelImpl();
  final SnackModel _mSnackModel = SnackModelImpl();
  final _cardNumber = TextEditingController();
  final _cardHolder = TextEditingController();
  final _expireDate = TextEditingController();
  final _cvc = TextEditingController();
  List<CardVO>? _mMyCardList;
  CardVO? _mSelectedCard;

  CheckOutRequest _mCheckOutVO = CheckOutRequest(
    cinemaDayTimeSlotId: 1,
    seatNumber: "L-13",
    bookingDate: "2021-6-29",
    movieId: 337404,
    cardId: 4,
    snacks: [
      SnackRequest(
        id: 1,
        count: 2,
      ),
    ],
  );

  @override
  void initState() {
    _initCardList();
    super.initState();
  }

  @override
  void dispose() {
    _cardNumber.dispose();
    _cardHolder.dispose();
    _expireDate.dispose();
    _cvc.dispose();
    super.dispose();
  }

  void _initCardList() {
    /// from database
    /// user
    _mUserModel.getUserProfileFromDatabase(_mAuthModel.getTokenFromDatabase()!).listen((value) {
      setState(() {
        _mMyCardList = value!.cards;
        _mSelectedCard = _mMyCardList![0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mMyCardList == null
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
                      height: MARGIN_MEDIUM,
                    ),
                    PaymentAmountSectionView(
                      paymentAmount: widget.paymentAmount,
                    ),
                    SizedBox(
                      height: MARGIN_MEDIUM_3,
                    ),
                    Visibility(
                      visible: _mMyCardList!.isNotEmpty,
                      child: HorizontalCreditCardListSectionView(
                          cardList: _mMyCardList!,
                          onTapCard: (card) {
                            setState(() {
                              _mSelectedCard = card;
                            });
                          }),
                    ),
                    SizedBox(
                      height: MARGIN_MEDIUM_3,
                    ),
                    AddNewCardView(
                      cardHolderController: TextEditingController(
                          text: _mSelectedCard!.cardHolder),
                      expireDateController: TextEditingController(
                          text: _mSelectedCard!.expirationDate),
                      cardNumberController: TextEditingController(
                          text: _mSelectedCard!.cardNumber),
                      cvcController:
                          TextEditingController(text: _mSelectedCard!.cardType),
                    ),
                    SizedBox(
                      height: MARGIN_MEDIUM_3,
                    ),
                    AddNewCardButtonView(
                      () => _navigateToAddNewCardPage(context),
                    ),
                    SizedBox(
                      height: MARGIN_MEDIUM_3,
                    ),
                    ConfirmButtonView(
                      () => _checkOut(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _checkOut() {
    _mMovieModel.getSelectedMovieIdFromDatabase().then((value) {
      _mCheckOutVO.movieId = value;
    });

    _mCinemaModel.getSelectedCinemaDayTimeSlotsFromDatabase().then((value) {
      _mCheckOutVO.cinemaDayTimeSlotId = value.timeslots
          .where((element) => element.isSelected == true)
          .first
          .cinemaDayTimeslotId;
      _mCheckOutVO.cardId = _mSelectedCard!.id;
      _mCheckOutVO.bookingDate = value.bookingDate;
    });

    _mCinemaModel.getSelectedMovieSeatFromDatabase().then((value) {
      value.forEach((element) {
        _mCheckOutVO.seatNumber = element.seatName;
      });
    });

    _mSnackModel.getSelectedSnacksFromDatabase().then((value) {
      value.forEach((element) {
        _mCheckOutVO.snacks!
            .add(SnackRequest(id: element.id, count: element.count));
      });
    });

    _mPaymentModel
        .checkOut(_mAuthModel.getTokenFromDatabase()!, _mCheckOutVO)
        .then((value) {
      /// clear selection from database
      _mPaymentModel.clearSelectedInDatabase();
      _navigateToTicketPage(context, value!.id);
    }).catchError((error) {
      handleError(context: context, error: error);
    });
  }

  void _navigateToAddNewCardPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return AddNewCardPage();
      }),
    ).then((value) {
      _initCardList();
    });
  }

  void _navigateToTicketPage(BuildContext context, int transactionId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return TicketPage(
          transactionId: transactionId,
        );
      }),
    );
  }
}

class ConfirmButtonView extends StatelessWidget {
  final Function onTapConfirmButton;

  ConfirmButtonView(
    this.onTapConfirmButton,
  );

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
        CONFIRM_BUTTON_TEXT,
        PRIMARY_COLOR,
        () => onTapConfirmButton(),
      ),
    );
  }
}

class AddNewCardButtonView extends StatelessWidget {
  final Function onTapAddNewCard;

  AddNewCardButtonView(
    this.onTapAddNewCard,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: GestureDetector(
        onTap: () => onTapAddNewCard(),
        child: Row(
          children: [
            Icon(
              Icons.add_circle,
              color: ADD_NEW_CARD_BUTTON_AND_TEXT_COLOR,
            ),
            SizedBox(
              width: MARGIN_MEDIUM,
            ),
            Text(
              ADD_NEW_CARD_TEXT,
              style: TextStyle(
                color: ADD_NEW_CARD_BUTTON_AND_TEXT_COLOR,
                fontSize: TEXT_REGULAR_3X,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalCreditCardListSectionView extends StatelessWidget {
  final List<CardVO> cardList;
  final Function(CardVO) onTapCard;

  const HorizontalCreditCardListSectionView({
    required this.cardList,
    required this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 8 * 2,
      child: CarouselSlider(
        items: cardList
            .map(
              (card) => CreditCardView(
                card: card,
                onTapCard: (card) => onTapCard(card),
              ),
            )
            .toList(),
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
      ),
    );
  }
}

class PaymentAmountSectionView extends StatelessWidget {
  final double paymentAmount;

  const PaymentAmountSectionView({required this.paymentAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MARGIN_MEDIUM_2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTextView(
            PAYMENT_AMOUNT_TEXT,
          ),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          Text(
            "\$$paymentAmount",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: TEXT_HEADING_2X,
            ),
          ),
        ],
      ),
    );
  }
}
