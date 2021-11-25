import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:movie_ticket/data/models/movie_model.dart';
import 'package:movie_ticket/data/models/movie_model_impl.dart';
import 'package:movie_ticket/data/models/payment_model.dart';
import 'package:movie_ticket/data/models/payment_model_impl.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/network/api_constants.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/widgets/back_button_view.dart';

class TicketPage extends StatefulWidget {
  final int transactionId;

  const TicketPage({required this.transactionId});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final PaymentModel _mPaymentModel = PaymentModelImpl();
  final MovieModel _mMovieModel = MovieModelImpl();
  TransactionVO? _mTransactionVO;
  MovieVO? _movie;

  @override
  void initState() {
    /// from network
    _mPaymentModel
        .getTransactionVOByIdFromDatabase(widget.transactionId)
        .then((value) {
      setState(() {
        _mTransactionVO = value;
      });

      /// movie detail from database
      _mMovieModel
          .getMovieDetailFromDatabase(_mTransactionVO?.movieId ?? 0)
          .listen((value) {
        setState(() {
          _movie = value;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mTransactionVO == null || _movie == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  bottom: MARGIN_MEDIUM_2,
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackButtonView(
                      Icons.close,
                      () => Navigator.pop(context),
                    ),
                    CongretTextSectionView(),
                    SizedBox(
                      height: MARGIN_MEDIUM_2,
                    ),
                    TicketDetailSectionView(
                      movie: _movie,
                      transaction: _mTransactionVO,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class TicketDetailSectionView extends StatelessWidget {
  final MovieVO? movie;
  final TransactionVO? transaction;

  const TicketDetailSectionView({
    required this.movie,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          PAYMENT_CARD_BORDER_RADIUS,
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoviePosterView(
            posterPath: movie?.posterPath,
          ),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          MovieNameAndLengthSectionView(
            movieName: movie?.originalTitle,
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          DividerView(),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          TicketInfoSectionView(
            transaction: transaction,
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          DividerView(),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          BarCodeView(),
        ],
      ),
    );
  }
}

class DividerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        500 ~/ 10,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : Colors.black54,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class BarCodeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MARGIN_XXLARGE),
      child: BarcodeWidget(
        barcode: Barcode.code128(),
        height: 80,
        data: "GD002281991829",
        style: TextStyle(
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class TicketInfoSectionView extends StatelessWidget {
  final TransactionVO? transaction;

  const TicketInfoSectionView({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Column(
        children: [
          TicketInfoView(
            "Booking no",
            transaction?.bookingNo ?? "-",
          ),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          TicketInfoView(
            "Show time - Date",
            transaction?.bookingDate ?? "-",
          ),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          TicketInfoView(
            "Theater",
            transaction?.cinemaId.toString(),
          ),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          TicketInfoView(
            "Screen",
            "2",
          ),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          TicketInfoView(
            "Row",
            transaction?.row ?? "-",
          ),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          TicketInfoView(
            "Seats",
            transaction?.seat ?? "-",
          ),
          SizedBox(
            height: MARGIN_LARGE,
          ),
          TicketInfoView(
            "Price",
            "${transaction?.total}",
          ),
        ],
      ),
    );
  }
}

class TicketInfoView extends StatelessWidget {
  final String label;
  final String? text;

  TicketInfoView(
    this.label,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: TICKET_INFO_LABEL_TEXT_COLOR,
          ),
        ),
        Spacer(),
        Text(
          text ?? "-",
          style: TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: TICKET_INFO_TEXT_COLOR,
          ),
        ),
      ],
    );
  }
}

class MoviePosterView extends StatelessWidget {
  final String? posterPath;

  const MoviePosterView({required this.posterPath});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "$IMAGE_BASE_URL$posterPath",
      height: MediaQuery.of(context).size.height / 4,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class MovieNameAndLengthSectionView extends StatelessWidget {
  final String? movieName;

  const MovieNameAndLengthSectionView({this.movieName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieName ?? "-",
            style: TextStyle(
              fontSize: TEXT_REGULAR_3X,
              color: TICKET_INFO_TEXT_COLOR,
            ),
          ),
          SizedBox(
            height: MARGIN_SMALL,
          ),
          Text(
            "105m - IMAX",
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              color: TICKET_INFO_LABEL_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}

class CongretTextSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            AWESOME_TEXT,
            style: TextStyle(
              fontSize: TEXT_HEADING_2X,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MARGIN_SMALL,
          ),
          Text(
            YOUR_TICKET_TEXT,
            style: TextStyle(
              color: TICKET_INFO_LABEL_TEXT_COLOR,
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
        ],
      ),
    );
  }
}
