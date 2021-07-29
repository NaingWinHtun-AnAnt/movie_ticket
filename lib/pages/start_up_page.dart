import 'package:flutter/material.dart';
import 'package:movie_ticket/pages/login_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';

class StartUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          bottom: MARGIN_XXLARGE,
          left: MARGIN_MEDIUM_2,
          right: MARGIN_MEDIUM_2,
        ),
        color: PRIMARY_COLOR,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            GetStartedImageSectionView(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
            ),
            GreetingTextSectionView(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
            ),
            LongButtonView(
              GET_STARTED_BUTTON_TEXT,
              PRIMARY_COLOR,
              () => _navigateToLoginPage(context),
              isGhostButton: true,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLoginPage(BuildContext context) {
     Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => LogInPage(),
      ),
    );
  }
}

class GetStartedImageSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      "https://i.dlpng.com/static/png/4793030-bitcoin-cryptocurrency-exchange-bitcoin-trading-platform-kraken-traded-png-1440_1374_preview.png",
      width: GET_STARTED_IMAGE_SIZE,
      height: GET_STARTED_IMAGE_SIZE,
    );
  }
}

class GreetingTextSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          GET_STARTED_PAGE_WELCOME_TEXT,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: TEXT_HEADING_1X,
          ),
        ),
        SizedBox(
          height: MARGIN_SMALL,
        ),
        Text(
          GET_STARTED_PAGE_GREETING_TEXT,
          style: TextStyle(
            fontSize: TEXT_REGULAR,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
