import 'package:flutter/material.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';

class LabelTextView extends StatelessWidget {
  final String labelText;

  LabelTextView(this.labelText);

  @override
  Widget build(BuildContext context) {
    return Text(
      labelText,
      style: TextStyle(
        fontSize: TEXT_REGULAR_2X,
        color: TICKET_INFO_LABEL_TEXT_COLOR,
      ),
    );
  }
}
