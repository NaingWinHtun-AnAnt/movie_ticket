import 'package:flutter/material.dart';
import 'package:movie_ticket/resources/dimens.dart';

class LongButtonView extends StatelessWidget {
  final String labelText;
  final Color backgroundColor;
  final bool isGhostButton;
  final Function onTapButton;

  LongButtonView(
    this.labelText,
    this.backgroundColor,
    this.onTapButton, {
    this.isGhostButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapButton();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MARGIN_MEDIUM_3,
        ),
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: TEXT_REGULAR_2X,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              LONG_BUTTON_BORDER_RADIUS,
            ),
          ),
          border: isGhostButton
              ? Border.all(
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
