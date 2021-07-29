import 'package:flutter/material.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/data/models/cinema_model.dart';
import 'package:movie_ticket/data/models/cinema_model_impl.dart';
import 'package:movie_ticket/data/models/movie_model.dart';
import 'package:movie_ticket/data/models/movie_model_impl.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/data/vos/time_slot_vo.dart';
import 'package:movie_ticket/pages/tickets_and_payments_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';

class MovieSeatPage extends StatefulWidget {
  final TimeSlotVO timeSlot;
  final String selectedDate;
  final String cinemaName;
  final int movieId;

  const MovieSeatPage({
    required this.timeSlot,
    required this.selectedDate,
    required this.movieId,
    required this.cinemaName,
  });

  @override
  State<MovieSeatPage> createState() => _MovieSeatPageState();
}

class _MovieSeatPageState extends State<MovieSeatPage> {
  final CinemaModel _mCinemaModel = CinemaModelImpl();
  final MovieModel _mMovieModel = MovieModelImpl();
  final AuthenticationModel _mAuthModel = AuthenticationModelImpl();
  MovieVO? _movie;
  List<MovieSeatVO>? _movieSeats;
  double _totalSeatPrice = 0.0;

  @override
  void initState() {
    _mCinemaModel
        .getSeatPlan(
      _mAuthModel.getTokenFromDatabase()!,
      widget.timeSlot.cinemaDayTimeslotId,
      widget.selectedDate,
    )
        .then((value) {
      setState(() {
        _movieSeats = value;
      });
    });

    /// from database
    // _mMovieTicketModel.getAllMovieSeatFromDatabase().then((value) {
    //   print(value.length);
    //   setState(() {
    //     _movieSeats = value;
    //   });
    // });

    _mMovieModel.getMovieDetailFromDatabase(widget.movieId).then((value) {
      setState(() {
        _movie = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: MARGIN_XLARGE,
          ),
        ),
      ),
      body: _movieSeats == null || _movie == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MovieNameTimeAndCinemaSectionView(
                      movieName: _movie!.originalTitle,
                      cinemaName: widget.cinemaName,
                      dateTime:
                          "${widget.selectedDate},${widget.timeSlot.starTime}",
                    ),
                    SizedBox(
                      height: MARGIN_LARGE,
                    ),
                    MovieSeatSectionView(
                      movieSeats: _movieSeats!,
                      onTapMovieSeat: (movieSeat) => _onTapMovieSeat(movieSeat),
                    ),
                    SizedBox(
                      height: MARGIN_MEDIUM_2,
                    ),
                    SeatGlossarySectionView(),
                    SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    DividerView(),
                    SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    TicketAndSeatSectionView(
                      seatList: _movieSeats!
                          .where((element) => element.isSelected == true)
                          .toList(),
                    ),
                    SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: MARGIN_MEDIUM_2,
                      ),
                      child: LongButtonView(
                        "Buy Ticket For \$$_totalSeatPrice",
                        PRIMARY_COLOR,
                        () => _navigateToPaymentPage(context),
                      ),
                    ),
                    SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _onTapMovieSeat(
    MovieSeatVO selectedSeat,
  ) {
    final isSelected = selectedSeat.isSelected;
    setState(() {
      _movieSeats = _movieSeats!.map((seat) {
        if (seat == selectedSeat) {
          seat.isSelected = !isSelected!;
          seat.isSelected!
              ? _totalSeatPrice += seat.price!
              : _totalSeatPrice -= seat.price!;
        }
        return seat;
      }).toList();
    });

    /// save selected seat to database
    _mCinemaModel.saveSelectedSeatToDatabase(selectedSeat);
  }

  void _navigateToPaymentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => TicketsAndPaymentPage(
          ticketTotalPrice: _totalSeatPrice,
        ),
      ),
    );
  }
}

class TicketAndSeatSectionView extends StatelessWidget {
  final List<MovieSeatVO> seatList;

  const TicketAndSeatSectionView({required this.seatList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TicketAndSeatTextView(
          "Tickets",
          seatList.length.toString(),
        ),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        TicketAndSeatTextView(
          "Seat",
          seatList.isEmpty ? "-" : seatList.map((e) => e.seatName).join("/"),
        ),
      ],
    );
  }
}

class TicketAndSeatTextView extends StatelessWidget {
  final String label;
  final String text;

  TicketAndSeatTextView(
    this.label,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.w700,
              color: TICKET_INFO_LABEL_TEXT_COLOR,
            ),
          ),
          Spacer(),
          Text(
            text,
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.w700,
              color: TICKET_INFO_LABEL_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}

class DividerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Row(
        children: List.generate(
          500 ~/ 10,
          (index) => Expanded(
            child: Container(
              color: index % 2 == 0 ? Colors.transparent : Colors.black54,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class SeatGlossarySectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MovieSeatGlossaryView(
              SEAT_COLOR,
              SEAT_AVAILABLE,
            ),
          ),
          Expanded(
            flex: 1,
            child: MovieSeatGlossaryView(
              SEAT_TAKEN_COLOR,
              SEAT_TAKEN,
            ),
          ),
          Expanded(
            flex: 1,
            child: MovieSeatGlossaryView(
              PRIMARY_COLOR,
              SEAT_YOUR_SELECTION,
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSeatGlossaryView extends StatelessWidget {
  final Color color;
  final String text;

  MovieSeatGlossaryView(
    this.color,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: MARGIN_MEDIUM,
        ),
        Text(
          text,
        ),
      ],
    );
  }
}

class MovieSeatSectionView extends StatelessWidget {
  final List<MovieSeatVO> movieSeats;
  final Function(MovieSeatVO) onTapMovieSeat;

  const MovieSeatSectionView({
    required this.movieSeats,
    required this.onTapMovieSeat,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movieSeats.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return SeatView(
          movieSeatVO: movieSeats[index],
          onTapMovieSeat: (movieSeat) => onTapMovieSeat(movieSeat),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 14,
        childAspectRatio: 1,
      ),
    );
  }
}

class SeatView extends StatelessWidget {
  final MovieSeatVO movieSeatVO;
  final Function(MovieSeatVO) onTapMovieSeat;

  SeatView({
    required this.movieSeatVO,
    required this.onTapMovieSeat,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapMovieSeat(
        movieSeatVO,
      ),
      child: Container(
        margin: EdgeInsets.all(
          MARGIN_SMALL,
        ),
        decoration: BoxDecoration(
          color: _movieSeatColor(
            movieSeatVO,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              MARGIN_MEDIUM,
            ),
            topRight: Radius.circular(
              MARGIN_MEDIUM,
            ),
          ),
        ),
        child: Center(
          child: Text(
            movieSeatVO.isMovieSeatTitle() ? movieSeatVO.title! : "",
          ),
        ),
      ),
    );
  }

  Color _movieSeatColor(MovieSeatVO seat) {
    if (seat.isMovieSeatTaken()) {
      return SEAT_TAKEN_COLOR;
    } else if (seat.isMovieSeatAvailable()) {
      return seat.isSelected! ? PRIMARY_COLOR : SEAT_COLOR;
    } else {
      return Colors.white;
    }
  }
}

class MovieNameTimeAndCinemaSectionView extends StatelessWidget {
  final String movieName;
  final String cinemaName;
  final String dateTime;

  const MovieNameTimeAndCinemaSectionView({
    required this.movieName,
    required this.cinemaName,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            movieName,
            style: TextStyle(
              color: Colors.black,
              fontSize: TEXT_REGULAR_3X,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: MARGIN_SMALL,
          ),
          Text(
            cinemaName,
            style: TextStyle(
              color: MOVIE_CINEMA_COLOR,
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
          SizedBox(
            height: MARGIN_SMALL,
          ),
          Text(
            dateTime,
            style: TextStyle(
              color: MOVIE_DATE_AND_TIME_COLOR,
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
        ],
      ),
    );
  }
}
