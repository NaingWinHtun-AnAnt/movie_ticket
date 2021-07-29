import 'package:flutter/material.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';

class TitleText extends StatelessWidget {
  final String titleText;

  TitleText(
    this.titleText,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        fontSize: TEXT_REGULAR_3X,
        color: TITLE_TEXT_COLOR,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
