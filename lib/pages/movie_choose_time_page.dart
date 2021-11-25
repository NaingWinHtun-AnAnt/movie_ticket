import 'package:flutter/material.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/data/models/cinema_model.dart';
import 'package:movie_ticket/data/models/cinema_model_impl.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/data/vos/date_vo.dart';
import 'package:movie_ticket/data/vos/time_slot_vo.dart';
import 'package:movie_ticket/dummy/dummy_data.dart';
import 'package:movie_ticket/pages/movie_seat_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';

class MovieChooseTimePage extends StatefulWidget {
  final int movieId;

  const MovieChooseTimePage({
    required this.movieId,
  });

  @override
  State<MovieChooseTimePage> createState() => _MovieChooseTimePageState();
}

class _MovieChooseTimePageState extends State<MovieChooseTimePage> {
  final CinemaModel _mCinemaModel = CinemaModelImpl();
  final AuthenticationModel _mAuthModel = AuthenticationModelImpl();
  List<CinemaDayTimeSlotVO>? _mCinemaList;

  @override
  void initState() {
    _getCinemaByDate(dummyDateList[0].formattedDate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: HOME_SCREEN_SEARCH_AND_MENU_ICON_SIZE,
          ),
        ),
      ),
      body: _mCinemaList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MovieChooseDateView(
                      dateList: dummyDateList,
                      onTapDate: (date, value) {
                        setState(() {
                          dummyDateList = dummyDateList.map((date) {
                            date.isSelected = false;
                            return date;
                          }).map((myDate) {
                            if (myDate.formattedDate == date)
                              myDate.isSelected = true;
                            return myDate;
                          }).toList();
                        });
                        _getCinemaByDate(date);
                      },
                    ),
                    ChooseItemGridSectionView(
                      cinemaList: _mCinemaList,
                      onTapTimeSlot: (cinemaId, timeSlotId, timeSlotValue) =>
                          _onTapTimeSlotView(
                        cinemaId,
                        timeSlotId,
                        timeSlotValue,
                      ),
                    ),
                    SizedBox(
                      height: MARGIN_LARGE,
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2,
        ),
        child: LongButtonView(
          "Next",
          PRIMARY_COLOR,
          () {
            _navigateToMovieSeatPage(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _getCinemaByDate(String date) {
    /// from database
    _mCinemaModel
        .getCinemaDayTimeSlotsFromDatabase(
            _mAuthModel.getTokenFromDatabase(), date)
        .listen(
      (value) {
        setState(() {
          _mCinemaList = value;
        });
      },
    );
  }

  void _onTapTimeSlotView(int timeSlotId, int cinemaId, bool timeSlotValue) {
    setState(() {
      _mCinemaList?.map((cinema) {
        cinema.isSelected = false;
        return cinema;
      }).map((myCinema) {
        if (myCinema.cinemaId == cinemaId) myCinema.isSelected = true;
        myCinema.timeslots?.map((timeSlot) {
          timeSlot.isSelected = false;
          return timeSlot;
        }).map((myTimeSlot) {
          if (myTimeSlot.cinemaDayTimeslotId == timeSlotId)
            myTimeSlot.isSelected = !timeSlotValue;
          return myTimeSlot;
        }).toList();
        return myCinema;
      }).toList();
    });
  }

  void _navigateToMovieSeatPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MovieSeatPage(
          timeSlot: _mCinemaList
              ?.where((movie) => movie.isSelected == true)
              .first
              .timeslots
              ?.where((timeSlot) => timeSlot.isSelected == true)
              .first,
          selectedDate: dummyDateList
              .where((element) => element.isSelected == true)
              .first
              .formattedDate,
          movieId: widget.movieId,
          cinemaName: _mCinemaList
              ?.where((element) => element.isSelected == true)
              .first
              .cinema,
        ),
      ),
    );
  }
}

class ChooseItemGridSectionView extends StatelessWidget {
  final List<CinemaDayTimeSlotVO>? cinemaList;
  final Function(int, int, bool) onTapTimeSlot;

  const ChooseItemGridSectionView(
      {required this.cinemaList, required this.onTapTimeSlot});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(
        top: MARGIN_MEDIUM_2,
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
      ),
      color: Colors.white,
      child: ListView.builder(
        itemCount: cinemaList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) => ChooseItemGridView(
          cinema: cinemaList?[index],
          onTapTimeSlot: (cinemaId, timeSlotId, timeSlotValue) =>
              onTapTimeSlot(cinemaId, timeSlotId, timeSlotValue),
        ),
      ),
    );
  }
}

class ChooseItemGridView extends StatelessWidget {
  final CinemaDayTimeSlotVO? cinema;
  final Function(int, int, bool) onTapTimeSlot;

  const ChooseItemGridView({required this.cinema, required this.onTapTimeSlot});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cinema?.cinema ?? "-",
          style: TextStyle(
            color: Colors.black,
            fontSize: TEXT_REGULAR_3X,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cinema?.timeslots?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (BuildContext context, int index) {
            return TimeSlotView(
              timeSlot: cinema?.timeslots?[index],
              onTapTimeSlot: (timeSlotId, value) =>
                  onTapTimeSlot(timeSlotId, cinema?.cinemaId ?? 0, value),
            );
          },
        ),
        SizedBox(
          height: MARGIN_LARGE,
        ),
      ],
    );
  }
}

class TimeSlotView extends StatelessWidget {
  final TimeSlotVO? timeSlot;
  final Function(int, bool) onTapTimeSlot;

  const TimeSlotView({required this.timeSlot, required this.onTapTimeSlot});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapTimeSlot(
        timeSlot?.cinemaDayTimeslotId ?? 0,
        timeSlot?.isSelected ?? true,
      ),
      child: Container(
        margin: EdgeInsets.only(
          top: MARGIN_MEDIUM_2,
          left: MARGIN_MEDIUM_2,
          right: MARGIN_MEDIUM_2,
        ),
        decoration: BoxDecoration(
          color: timeSlot?.isSelected ?? false ? PRIMARY_COLOR : Colors.white,
          borderRadius: BorderRadius.circular(
            MARGIN_MEDIUM,
          ),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            timeSlot?.starTime ?? "-",
          ),
        ),
      ),
    );
  }
}

class MovieChooseDateView extends StatelessWidget {
  final List<DateVO> dateList;
  final Function(String, bool) onTapDate;

  const MovieChooseDateView({
    required this.dateList,
    required this.onTapDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      height: MOVIE_CHOOSE_DATE_SECTION_HEIGHT,
      padding: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: MARGIN_MEDIUM_2,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return DateView(onTapDate: onTapDate, date: dateList[index]);
        },
      ),
    );
  }
}

class DateView extends StatelessWidget {
  final DateVO date;
  final Function(String, bool) onTapDate;

  const DateView({
    required this.date,
    required this.onTapDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapDate(
        date.formattedDate,
        date.isSelected,
      ),
      child: Container(
        width: DATE_SELECT_ITEM_WIDTH,
        color: PRIMARY_COLOR,
        child: Column(
          children: [
            Text(
              date.day,
              style: TextStyle(
                fontSize: TEXT_REGULAR_3X,
                color: date.isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            SizedBox(
              height: MARGIN_MEDIUM,
            ),
            Text(
              date.date,
              style: TextStyle(
                fontSize: TEXT_REGULAR_3X,
                color: date.isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
