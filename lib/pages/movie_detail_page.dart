import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_ticket/data/models/movie_model.dart';
import 'package:movie_ticket/data/models/movie_model_impl.dart';
import 'package:movie_ticket/data/vos/cast_vo.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/network/api_constants.dart';
import 'package:movie_ticket/pages/movie_choose_time_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';
import 'package:movie_ticket/widgets/back_button_view.dart';
import 'package:movie_ticket/widgets/title_text.dart';

class MovieDetailPage extends StatefulWidget {
  final String token;
  final int movieId;

  MovieDetailPage({
    required this.token,
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieModel _mMovieModel = MovieModelImpl();
  MovieVO? _mMovieDetail;

  @override
  void initState() {
    /// from database
    _mMovieModel.getMovieDetailFromDatabase(widget.movieId).then((value) {
      if (value != null)
        setState(() {
          _mMovieDetail = value;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mMovieDetail == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: CustomScrollView(
                slivers: [
                  SliverAppBarView(movie: _mMovieDetail!),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        MovieInfoSectionView(
                          movieDetail: _mMovieDetail!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GetTicketButtonView(
        GET_YOUR_TICKET_TEXT,
        () => _navigateToTicketAndPaymentPage(context),
      ),
    );
  }

  void _navigateToTicketAndPaymentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MovieChooseTimePage(
          movieId: _mMovieDetail!.id,
        ),
        // TicketsAndPaymentPage(),
      ),
    );
  }
}

class SliverAppBarView extends StatelessWidget {
  final MovieVO movie;

  const SliverAppBarView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: PRIMARY_COLOR,
      expandedHeight: MediaQuery.of(context).size.height * 0.5,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    MovieDetailImageView(
                      imageUrl: movie.posterPath,
                    ),
                    MovieDetailBackButtonView(),
                    PlayButtonView(),
                  ],
                ),
              ),
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        SLIVER_APP_BAR_BORDER_RADIUS_SIZE,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class GetTicketButtonView extends StatelessWidget {
  final String buttonText;
  final Function onTapButton;

  GetTicketButtonView(
    this.buttonText,
    this.onTapButton,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: LongButtonView(
        buttonText,
        PRIMARY_COLOR,
        () => onTapButton(),
      ),
    );
  }
}

class MovieInfoSectionView extends StatelessWidget {
  final MovieVO movieDetail;

  MovieInfoSectionView({
    required this.movieDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            MOVIE_DETAIL_SLIVER_RADIUS,
          ),
          topRight: Radius.circular(
            MOVIE_DETAIL_SLIVER_RADIUS,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MovieNameView(movieDetail.originalTitle),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          MovieLengthAndRatingSectionView(
            rating: movieDetail.rating ?? 0.0,
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          GenreSectionView(genreList: movieDetail.genres),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          PlotAndSummarySectionView(
            overView: movieDetail.overview ?? "",
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          CastSectionView(
            casts: movieDetail.casts ?? [],
          )
        ],
      ),
    );
  }
}

class CastSectionView extends StatelessWidget {
  final List<CastVO> casts;

  const CastSectionView({
    required this.casts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: MARGIN_MEDIUM_2,
          ),
          child: TitleText(
            CAST_TEXT,
          ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        HorizontalCastListView(
          casts: casts,
        ),
        SizedBox(
          height: SIZE_BOX_HEIGHT_FOR_CUSTOM_SCROLL_VIEW,
        ),
      ],
    );
  }
}

class HorizontalCastListView extends StatelessWidget {
  final List<CastVO> casts;

  const HorizontalCastListView({required this.casts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_DETAIL_CAST_IMAGE_SIZE,
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: MARGIN_MEDIUM_2,
        ),
        itemCount: casts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return CastItemView(
            cast: casts[index],
          );
        },
      ),
    );
  }
}

class CastItemView extends StatelessWidget {
  final CastVO cast;

  const CastItemView({required this.cast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: MARGIN_MEDIUM_2,
      ),
      child: ClipOval(
        child: Image.network(
          "$IMAGE_BASE_URL/${cast.profilePath}",
          fit: BoxFit.cover,
          width: MOVIE_DETAIL_CAST_IMAGE_SIZE,
        ),
      ),
    );
  }
}

class GenreSectionView extends StatelessWidget {
  const GenreSectionView({
    required this.genreList,
  });

  final List<String> genreList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Wrap(
        direction: Axis.horizontal,
        children: genreList
            .map(
              (genreText) => ChipView(genreText),
            )
            .toList(),
      ),
    );
  }
}

class MovieLengthAndRatingSectionView extends StatelessWidget {
  final double rating;

  const MovieLengthAndRatingSectionView({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "1h 45m",
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
          SizedBox(
            width: MARGIN_MEDIUM_2,
          ),
          RatingBar.builder(
            itemSize: RATING_BAR_SIZE,
            initialRating: rating,
            itemBuilder: (context, _) => Icon(
              Icons.star_rounded,
              color: RATING_STAR_COLOR,
            ),
            onRatingUpdate: (double value) {},
          ),
          SizedBox(
            width: MARGIN_MEDIUM_2,
          ),
          Text(
            "IMDb $rating",
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
        ],
      ),
    );
  }
}

class MovieNameView extends StatelessWidget {
  final String movieName;

  MovieNameView(
    this.movieName,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MARGIN_MEDIUM,
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
      ),
      child: Text(
        movieName,
        style: TextStyle(
          fontSize: TEXT_HEADING_1X,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class PlayButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Icon(
        Icons.play_circle_outline,
        color: Colors.white70,
        size: MOVIE_DETAIL_PLAY_BUTTON_SIZE,
      ),
    );
  }
}

class MovieDetailBackButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: BackButtonView(
        Icons.chevron_left,
        () => Navigator.pop(context),
        color: Colors.white,
      ),
    );
  }
}

class MovieDetailImageView extends StatelessWidget {
  final String imageUrl;

  const MovieDetailImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        "$IMAGE_BASE_URL$imageUrl",
        fit: BoxFit.cover,
      ),
    );
  }
}

class PlotAndSummarySectionView extends StatelessWidget {
  final String overView;

  const PlotAndSummarySectionView({required this.overView});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText("Plot Summary"),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          Text(
            overView,
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              height: 1.6,
              color: PLOT_SUMMARY_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}

class ChipView extends StatelessWidget {
  final String genreText;

  ChipView(
    this.genreText,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
          backgroundColor: Colors.transparent,
          shape: StadiumBorder(
            side: BorderSide(
              color: Colors.grey,
            ),
          ),
          label: Text(genreText),
        ),
        SizedBox(
          width: MARGIN_MEDIUM,
        ),
      ],
    );
  }
}
