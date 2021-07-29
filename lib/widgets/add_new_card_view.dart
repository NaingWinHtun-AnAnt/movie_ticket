import 'package:flutter/material.dart';
import 'package:movie_ticket/data/vos/card_vo.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/widgets/text_field_view.dart';

import 'label_text_view.dart';

class AddNewCardView extends StatefulWidget {
  final CardVO? card;
  final TextEditingController cardNumberController;
  final TextEditingController cardHolderController;
  final TextEditingController expireDateController;
  final TextEditingController cvcController;

  const AddNewCardView({
    this.card,
    required this.cardNumberController,
    required this.cardHolderController,
    required this.expireDateController,
    required this.cvcController,
  });

  @override
  State<AddNewCardView> createState() => _AddNewCardViewState();
}

class _AddNewCardViewState extends State<AddNewCardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Column(
        children: [
          LabelAndTextFieldView(
            labelText: CARD_NUMBER_TEXT,
            hintText: CARD_NUMBER_SAMPLE_TEXT,
            controller: widget.cardNumberController,
          ),
          SizedBox(
            height: MARGIN_MEDIUM_3,
          ),
          LabelAndTextFieldView(
            labelText: CARD_HOLDER_TEXT,
            hintText: CARD_HOLDER_SAMPLE_TEXT,
            controller: widget.cardHolderController,
          ),
          SizedBox(
            height: MARGIN_MEDIUM_3,
          ),
          ExpirationDateAndCVCSectionView(
            expireDateController: widget.expireDateController,
            cvcController: widget.cvcController,
          ),
        ],
      ),
    );
  }
}

class LabelAndTextFieldView extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;

  LabelAndTextFieldView({
    required this.labelText,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextView(labelText),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        TextFieldView(
          hintText: hintText,
          controller: controller,
        ),
      ],
    );
  }
}

class ExpirationDateAndCVCSectionView extends StatelessWidget {
  final TextEditingController expireDateController;
  final TextEditingController cvcController;

  const ExpirationDateAndCVCSectionView(
      {required this.expireDateController, required this.cvcController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            child: LabelAndTextFieldView(
              labelText: EXPIRATION_DATE_TEXT,
              hintText: EXPIRATION_DATE_SAMPLE_TEXT,
              controller: expireDateController,
            ),
          ),
        ),
        SizedBox(
          width: MARGIN_MEDIUM_3,
        ),
        Flexible(
          child: Container(
            child: LabelAndTextFieldView(
              labelText: CVC_TEXT,
              hintText: CVC_SAMPLE_TEXT,
              controller: cvcController,
            ),
          ),
        ),
      ],
    );
  }
}
