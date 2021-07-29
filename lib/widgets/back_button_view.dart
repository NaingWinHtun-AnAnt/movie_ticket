import 'package:flutter/material.dart';
import 'package:movie_ticket/resources/dimens.dart';

class BackButtonView extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onTapBackButton;

  BackButtonView(
    this.icon,
    this.onTapBackButton, {
    this.color = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapBackButton(),
      child: Container(
        margin: EdgeInsets.only(
          left: MARGIN_MEDIUM,
          top: MARGIN_XLARGE,
        ),
        child: Icon(
          icon,
          color: color,
          size: HOME_SCREEN_SEARCH_AND_MENU_ICON_SIZE,
        ),
      ),
    );
  }
}
