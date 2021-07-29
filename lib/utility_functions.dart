import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_ticket/network/responses/error_response.dart';
import 'package:movie_ticket/resources/dimens.dart';

void handleError({required BuildContext context, required dynamic error}) {
  if (error is DioError) {
    try {
      ErrorResponse errorResponse =
          ErrorResponse(message: error.response!.data);
      showErrorAlert(context, errorResponse.message);
    } on Error catch (e) {
      showErrorAlert(context, e.toString());
    }
  } else {
    showErrorAlert(context, error);
  }
}

void showErrorAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(MARGIN_MEDIUM_3),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: TEXT_REGULAR_3X,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                color: Colors.black54,
                padding: EdgeInsets.symmetric(
                  vertical: MARGIN_MEDIUM_2,
                ),
                child: Text(
                  "OK",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
