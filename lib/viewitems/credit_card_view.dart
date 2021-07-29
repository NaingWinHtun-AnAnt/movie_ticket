import 'package:flutter/material.dart';
import 'package:movie_ticket/data/vos/card_vo.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';

class CreditCardView extends StatelessWidget {
  final CardVO card;
  final Function(CardVO) onTapCard;

  const CreditCardView({
    required this.card,
    required this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapCard(card),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            PAYMENT_CARD_BORDER_RADIUS,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(
            MARGIN_MEDIUM_3,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CREDIT_CARD_START_COLOR,
                CREDIT_CARD_END_COLOR,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CreditCardType(
                    cardType: card.cardType,
                  ),
                  Spacer(),
                  Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ),
                ],
              ),
              Spacer(),
              CreditCardNumberTextView(
                cardNumber: card.cardNumber,
              ),
              Spacer(),
              CardHolderAndCVCLabelSectionView(
                cardHolder: CARD_HOLDER_LABEL,
                expDate: CARD_EXPIRE_LABEL,
              ),
              SizedBox(
                height: MARGIN_MEDIUM,
              ),
              CardHolderAndCVCTextSectionView(
                cardHolder: card.cardHolder,
                expDate: card.expirationDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardHolderAndCVCTextSectionView extends StatelessWidget {
  final String cardHolder;
  final String expDate;

  const CardHolderAndCVCTextSectionView(
      {required this.cardHolder, required this.expDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CreditCardLabelTextView(cardHolder),
        Spacer(),
        CreditCardLabelTextView(expDate),
      ],
    );
  }
}

class CreditCardLabelTextView extends StatelessWidget {
  final String text;

  CreditCardLabelTextView(
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: TEXT_REGULAR_2X,
      ),
    );
  }
}

class CardHolderAndCVCLabelSectionView extends StatelessWidget {
  final String cardHolder;
  final String expDate;

  const CardHolderAndCVCLabelSectionView(
      {required this.cardHolder, required this.expDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CreditCardTextView(label: cardHolder),
        Spacer(),
        CreditCardTextView(label: expDate),
      ],
    );
  }
}

class CreditCardTextView extends StatelessWidget {
  final String label;

  CreditCardTextView({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white54,
      ),
    );
  }
}

class CreditCardNumberTextView extends StatelessWidget {
  final String cardNumber;

  const CreditCardNumberTextView({required this.cardNumber});

  @override
  Widget build(BuildContext context) {
    return Text(
      cardNumber,
      style: TextStyle(
        fontSize: TEXT_HEADING_1X,
        color: Colors.white,
      ),
    );
  }
}

class CreditCardType extends StatelessWidget {
  final String cardType;

  const CreditCardType({required this.cardType});

  @override
  Widget build(BuildContext context) {
    return Text(
      cardType,
      style: TextStyle(
        fontSize: TEXT_HEADING_1X,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
