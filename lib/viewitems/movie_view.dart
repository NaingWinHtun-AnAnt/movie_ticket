import 'package:flutter/material.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/network/api_constants.dart';
import 'package:movie_ticket/resources/dimens.dart';

class MovieView extends StatelessWidget {
  final MovieVO? movie;
  final Function(int) onTapMovie;

  MovieView({
    required this.movie,
    required this.onTapMovie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: MARGIN_MEDIUM_2),
      width: MOVIE_VIEW_ITEM_WIDTH,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => onTapMovie(movie?.id ?? 0),
            child: Container(
              height: MOVIE_VIEW_ITEM_IMAGE_HEIGHT,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  MOVIE_VIEW_ITEM_IMAGE_BORDER_RADIUS,
                ),
              ),
              child: Image.network(
                "$IMAGE_BASE_URL${movie?.posterPath}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          Text(
            movie?.originalTitle ?? "-",
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            height: MARGIN_SMALL,
          ),
          Text(
            movie?.genres?.map((e) => e).join("/") ?? "-",
            style: TextStyle(
              fontSize: TEXT_SMALL,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
