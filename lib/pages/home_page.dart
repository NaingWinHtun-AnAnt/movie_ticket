import 'package:flutter/material.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/data/models/movie_model.dart';
import 'package:movie_ticket/data/models/movie_model_impl.dart';
import 'package:movie_ticket/data/models/user_model.dart';
import 'package:movie_ticket/data/models/user_model_impl.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';
import 'package:movie_ticket/pages/login_page.dart';
import 'package:movie_ticket/pages/movie_detail_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/viewitems/movie_view.dart';
import 'package:movie_ticket/widgets/title_text.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieModel _mMovieModel = MovieModelImpl();
  UserModel _mUserModel = UserModelImpl();
  AuthenticationModel _mAuthModel = AuthenticationModelImpl();
  List<MovieVO>? _nowShowingMovieList;
  List<MovieVO>? _comingSoonMovieList;
  UserVO? _mLoginUser;
  final List<String> menuItems = [
    "Promotion Code",
    "Select Language",
    "Terms of Services",
    "Help",
    "Rate Us",
  ];

  @override
  void initState() {
    /// from database
    /// now showing movie list
    _mMovieModel.getNowPlayingMovieListFromDatabase().listen((value) {
      setState(() {
        _nowShowingMovieList = value;
      });
    });

    /// coming soon movie list
    _mMovieModel.getComingSoonMovieListFromDatabase().listen((value) {
      setState(() {
        _comingSoonMovieList = value;
      });
    });

    /// user
    _mUserModel
        .getUserProfileFromDatabase(_mAuthModel.getTokenFromDatabase())
        .listen((value) {
      setState(() {
        _mLoginUser = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: [
          IconView(
            Icons.search,
          ),
          SizedBox(
            width: MARGIN_MEDIUM_2,
          ),
        ],
      ),
      body: _mLoginUser == null ||
              _nowShowingMovieList == null ||
              _comingSoonMovieList == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MARGIN_MEDIUM_2,
                  ),
                  GreetingSectionView(
                    user: _mLoginUser,
                  ),
                  SizedBox(
                    height: MARGIN_MEDIUM_2,
                  ),
                  MovieListSectionView(
                    titleText: NOW_SHOWING_TEXT,
                    movieList: _nowShowingMovieList,
                    onTapMovieView: (movieId) =>
                        _navigateToMovieDetailPage(context, movieId),
                  ),
                  SizedBox(
                    height: MARGIN_MEDIUM_3,
                  ),
                  MovieListSectionView(
                    titleText: COMING_SOON_TEXT,
                    movieList: _comingSoonMovieList,
                    onTapMovieView: (movieId) =>
                        _navigateToMovieDetailPage(context, movieId),
                  ),
                ],
              ),
            ),
      drawer: _mLoginUser == null
          ? Container()
          : Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Drawer(
                child: Container(
                  color: PRIMARY_COLOR,
                  padding: EdgeInsets.symmetric(
                    horizontal: MARGIN_MEDIUM_2,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: DRAWER_HEADER_SPACING_HEIGHT,
                      ),
                      DrawerHeaderSectionView(
                        loginUser: _mLoginUser,
                      ),
                      SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      DrawerActionSectionView(menuItems: menuItems),
                      Spacer(),
                      LogoutSectionView(
                        onTapLogout: () => _logout(context),
                      ),
                      SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _logout(BuildContext context) {
    _mAuthModel.logout(widget.token)?.then((value) {
      if (value?.code == 200) {
        _mAuthModel.clearAuthenticationFromDatabase();
        _navigateToLoginPage(context);
      }
    });
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => LogInPage(),
      ),
    );
  }

  void _navigateToMovieDetailPage(BuildContext context, int movieId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            MovieDetailPage(token: widget.token, movieId: movieId),
      ),
    );
  }
}

class DrawerActionSectionView extends StatelessWidget {
  const DrawerActionSectionView({
    required this.menuItems,
  });

  final List<String> menuItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: menuItems
          .map(
            (menu) => Container(
              margin: EdgeInsets.only(
                top: MARGIN_MEDIUM_2,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.help,
                  color: Colors.white,
                  size: MARGIN_XLARGE,
                ),
                title: Text(
                  menu,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: TEXT_REGULAR_3X,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class LogoutSectionView extends StatelessWidget {
  final Function onTapLogout;

  LogoutSectionView({required this.onTapLogout});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapLogout(),
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.white,
          size: MARGIN_XLARGE,
        ),
        title: Text(
          "Log out",
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_3X,
          ),
        ),
      ),
    );
  }
}

class DrawerHeaderSectionView extends StatelessWidget {
  final UserVO? loginUser;

  const DrawerHeaderSectionView({required this.loginUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: HOME_SCREEN_PROFILE_IMAGE_SIZE,
          height: HOME_SCREEN_PROFILE_IMAGE_SIZE,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://images.unsplash.com/photo-1529680459049-bf0340fa0755?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1868&q=80",
              ),
            ),
          ),
        ),
        SizedBox(
          width: MARGIN_MEDIUM_2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loginUser?.name ?? "-",
              style: TextStyle(
                color: Colors.white,
                fontSize: TEXT_REGULAR_3X,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: MARGIN_MEDIUM,
            ),
            Row(
              children: [
                Text(
                  loginUser?.email ?? "-",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: TEXT_SMALL,
                  ),
                ),
                SizedBox(
                  width: MARGIN_LARGE,
                ),
                Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class MovieListSectionView extends StatelessWidget {
  final String titleText;
  final List<MovieVO>? movieList;
  final Function(int) onTapMovieView;

  MovieListSectionView({
    required this.titleText,
    required this.movieList,
    required this.onTapMovieView,
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
            titleText,
          ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        HorizontalMovieListView(
          movieList: movieList,
          onTapMovieView: onTapMovieView,
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final List<MovieVO>? movieList;
  final Function(int) onTapMovieView;

  HorizontalMovieListView({
    required this.movieList,
    required this.onTapMovieView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HOME_SCREEN_MOVIE_LIST_VIEW_HEIGHT,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movieList?.length ?? 0,
        padding: EdgeInsets.only(
          left: MARGIN_MEDIUM_2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return MovieView(
            movie: movieList?[index],
            onTapMovie: onTapMovieView,
          );
        },
      ),
    );
  }
}

class GreetingSectionView extends StatelessWidget {
  final UserVO? user;

  GreetingSectionView({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: Row(
        children: [
          ProfileImageView(),
          SizedBox(
            width: MARGIN_MEDIUM_3,
          ),
          GreetingTextView(
            userName: user?.name ?? "-",
          ),
        ],
      ),
    );
  }
}

class GreetingTextView extends StatelessWidget {
  final String userName;

  const GreetingTextView({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hi $userName!",
      style: TextStyle(
        fontSize: TEXT_HEADING_2X,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class ProfileImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        "https://images.unsplash.com/photo-1529680459049-bf0340fa0755?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1868&q=80",
        height: HOME_SCREEN_PROFILE_IMAGE_SIZE,
        width: HOME_SCREEN_PROFILE_IMAGE_SIZE,
        fit: BoxFit.cover,
      ),
    );
  }
}

class IconView extends StatelessWidget {
  final IconData icon;

  const IconView(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.black,
      size: HOME_SCREEN_SEARCH_AND_MENU_ICON_SIZE,
    );
  }
}
