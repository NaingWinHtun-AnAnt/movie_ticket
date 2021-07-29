import 'package:flutter/material.dart';
import 'package:movie_ticket/resources/dimens.dart';

class LongButtonWithImageView extends StatelessWidget {
  final String url;
  final String label;
  final Function onTapButton;

  LongButtonWithImageView({
    required this.url,
    required this.label,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapButton(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MARGIN_MEDIUM_2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              url,
              width: SOCIAL_MEDIA_LOGIN_ICON_SIZE,
              height: SOCIAL_MEDIA_LOGIN_ICON_SIZE,
            ),
            SizedBox(
              width: MARGIN_LARGE,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              LONG_BUTTON_BORDER_RADIUS,
            ),
          ),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
