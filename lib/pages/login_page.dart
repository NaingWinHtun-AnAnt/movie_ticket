import 'dart:math';
import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/pages/home_page.dart';
import 'package:movie_ticket/resources/colors.dart';
import 'package:movie_ticket/resources/dimens.dart';
import 'package:movie_ticket/resources/strings.dart';
import 'package:movie_ticket/utility_functions.dart';
import 'package:movie_ticket/widgets/LongButtonView.dart';
import 'package:movie_ticket/widgets/long_button_with_image_view.dart';
import 'package:movie_ticket/widgets/text_field_view.dart';
import 'package:http/http.dart' as http;

class LogInPage extends StatefulWidget {
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthenticationModel _mAuthModel = AuthenticationModelImpl();
  final _formState = GlobalKey<FormState>();
  String? _randomNumber;
  String _googleAccessToken = "";
  String _facebookAccessToken = "";

  final List<String> tabs = [
    LOG_IN_TEXT,
    SIGN_IN_TEXT,
  ];

  @override
  void initState() {
    _randomNumber = Random().nextInt(123).toString();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MARGIN_XXLARGE,
              ),
              LoginPageWelcomeTextSectionView(),
              SizedBox(
                height: MARGIN_XLARGE,
              ),
              Flexible(
                child: TabsSectionView(
                  tabs: tabs,
                  onTapLoginButton: () => _onTapConfirmToLogin(context),
                  onTapLoginWithFacebook: () => _onTapFacebookLogin(),
                  onTapLoginWithGoogle: () => _onTapGoogleLogin(),
                  onTapRegisterButton: () => _onTapConfirmToRegister(context),
                  onTapRegisterWithFacebook: () =>
                      _onTapFacebookRegister(context),
                  onTapRegisterWithGoogle: () => _onTapGoogleRegister(context),
                  userNameController: _userNameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  passwordController: _passwordController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapFacebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'public_profile',
        'email',
        'pages_show_list',
        'pages_messaging',
        'pages_manage_metadata'
      ],
    );

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData(
        fields: "email,name",
      );
      setState(() {
        _emailController.text = userData['email'];
        _facebookAccessToken = result.accessToken!.token;
      });
      _mAuthModel.loginWithFacebook(_facebookAccessToken).then((value) {
        if (value.code == 200)
          _navigateToHomePage(context, _facebookAccessToken);
      }).catchError((error) {
        handleError(context: context, error: error);
      });
    }
  }

  void _onTapGoogleLogin() async {
    try {
      await _googleSignIn.signIn().then(
        (googleSignInAccount) {
          googleSignInAccount!.authentication.then((googleAuth) {
            setState(() {
              _emailController.text = googleSignInAccount.email;
              _googleAccessToken = googleAuth.accessToken!;
            });
            _mAuthModel.loginWithGoogle(_googleAccessToken).then((value) {
              if (value.code == 200)
                _navigateToHomePage(context, _googleAccessToken);
            }).catchError((error) {
              handleError(context: context, error: error);
            });
          });
        },
      );
    } catch (error) {
      print(error);
    }
  }

  void _onTapConfirmToLogin(BuildContext context) {
    if (_formState.currentState!.validate()) {
      _mAuthModel
          .loginWithEmail(_emailController.text, _passwordController.text)
          .then((value) {
        _navigateToHomePage(context, value.token!);
      }).catchError((error) {
        handleError(context: context, error: error);
      });
    }
  }

  void _onTapFacebookRegister(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'public_profile',
        'email',
        'pages_show_list',
        'pages_messaging',
        'pages_manage_metadata'
      ],
    );

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData(
        fields: "email,name",
      );

      final graphResponse =
          await http.get(Uri.https('graph.facebook.com', "/v2.12/me", {
        "fields": "name,picture,email",
        "access_token": "${result.accessToken!.token}",
      }));

      final profile = JSON.jsonDecode(graphResponse.body);

      setState(() {
        _emailController.text = userData['email'];
        _userNameController.text = "$_randomNumber${userData['name']}";

        _facebookAccessToken = profile['id'];
        _googleAccessToken = "";
      });
    }
  }

  void _onTapGoogleRegister(BuildContext context) async {
    try {
      await _googleSignIn.signIn().then(
        (googleSignInAccount) {
          googleSignInAccount!.authentication.then((value) {
            setState(() {
              _userNameController.text = googleSignInAccount.displayName!;
              _emailController.text = googleSignInAccount.email;
              _googleAccessToken = value.accessToken!;
              _facebookAccessToken = "";
            });
          });
        },
      );
    } catch (error) {
      handleError(context: context, error: error);
    }
  }

  void _onTapConfirmToRegister(BuildContext context) {
    print("Google Access Token = $_googleAccessToken");
    print("Facebook Access Token = $_facebookAccessToken");
    if (_formState.currentState!.validate()) {
      _mAuthModel
          .registerWithEmail(
        _userNameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
        _googleAccessToken,
        _facebookAccessToken,
      )
          .then((value) {
        _navigateToHomePage(context, value.token!);
      }).catchError((error) {
        handleError(context: context, error: error);
      });
    }
  }

  void _navigateToHomePage(BuildContext context, String token) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(
          token: "Bearer $token",
        ),
      ),
    );
  }
}

class ButtonSectionView extends StatelessWidget {
  final Function onTapFacebook;
  final Function onTapGoogle;
  final Function onTapConfirm;

  ButtonSectionView({
    required this.onTapFacebook,
    required this.onTapGoogle,
    required this.onTapConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LongButtonWithImageView(
          url:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/1024px-Facebook_Logo_%282019%29.png",
          label: SIGN_IN_WITH_FACEBOOK_TEXT,
          onTapButton: onTapFacebook,
        ),
        SizedBox(
          height: MARGIN_MEDIUM_3,
        ),
        LongButtonWithImageView(
          url:
              "https://upload.wikimedia.org/wikipedia/commons/2/2d/Google-favicon-2015.png",
          label: SIGN_IN_WITH_GOOGLE_TEXT,
          onTapButton: onTapGoogle,
        ),
        SizedBox(
          height: MARGIN_MEDIUM_3,
        ),
        LongButtonView(
          CONFIRM_BUTTON_TEXT,
          PRIMARY_COLOR,
          () => onTapConfirm(),
        ),
      ],
    );
  }
}

class SignInSectionView extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final Function onTapConfirm;
  final Function onTapRegisterWithFacebook;
  final Function onTapRegisterWithGoogle;

  const SignInSectionView({
    required this.userNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onTapConfirm,
    required this.onTapRegisterWithFacebook,
    required this.onTapRegisterWithGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldView(
              labelText: USER_NAME_TEXT,
              hintText: USER_NAME_HINT_TEXT,
              controller: userNameController,
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            TextFieldView(
              labelText: EMAIL_LABEL_TEXT,
              hintText: EMAIL_HINT_TEXT,
              controller: emailController,
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            TextFieldView(
              labelText: PHONE_NUMBER_TEXT,
              hintText: PHONE_NUMBER_HINT_TEXT,
              controller: phoneController,
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            TextFieldView(
              labelText: PASSWORD_LABEL_TEXT,
              hintText: PASSWORD_HINT_TEXT,
              controller: passwordController,
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            ButtonSectionView(
              onTapFacebook: onTapRegisterWithFacebook,
              onTapGoogle: onTapRegisterWithGoogle,
              onTapConfirm: onTapConfirm,
            ),
            SizedBox(
              height: MARGIN_XXLARGE,
            ),
          ],
        ),
      ),
    );
  }
}

class LogInSectionView extends StatelessWidget {
  final Function onTapConfirmButton;
  final Function onTapLoginWithFacebook;
  final Function onTapLoginWithGoogle;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LogInSectionView({
    required this.onTapConfirmButton,
    required this.onTapLoginWithFacebook,
    required this.onTapLoginWithGoogle,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldView(
              labelText: EMAIL_LABEL_TEXT,
              hintText: EMAIL_HINT_TEXT,
              controller: emailController,
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            TextFieldView(
              labelText: PASSWORD_LABEL_TEXT,
              hintText: PASSWORD_HINT_TEXT,
              controller: passwordController,
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            Text(
              FORGET_PASSWORD_TEXT,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: MARGIN_LARGE,
            ),
            ButtonSectionView(
              onTapFacebook: onTapLoginWithFacebook,
              onTapGoogle: onTapLoginWithGoogle,
              onTapConfirm: () => onTapConfirmButton(),
            ),
            SizedBox(
              height: MARGIN_XXLARGE,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPageWelcomeTextSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MARGIN_MEDIUM_2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GET_STARTED_PAGE_WELCOME_TEXT,
            style: TextStyle(
              color: Colors.black87,
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
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TabsSectionView extends StatelessWidget {
  final List<String> tabs;
  final Function onTapLoginButton;
  final Function onTapLoginWithFacebook;
  final Function onTapLoginWithGoogle;
  final Function onTapRegisterButton;
  final Function onTapRegisterWithFacebook;
  final Function onTapRegisterWithGoogle;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController userNameController;
  final TextEditingController phoneController;

  TabsSectionView({
    required this.tabs,
    required this.onTapLoginButton,
    required this.onTapLoginWithFacebook,
    required this.onTapLoginWithGoogle,
    required this.onTapRegisterButton,
    required this.onTapRegisterWithFacebook,
    required this.onTapRegisterWithGoogle,
    required this.emailController,
    required this.passwordController,
    required this.userNameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabsView(tabs),
          SizedBox(
            height: MARGIN_MEDIUM_3,
          ),
          Expanded(
            child: TabBarView(
              children: [
                LogInSectionView(
                  onTapConfirmButton: () => onTapLoginButton(),
                  onTapLoginWithFacebook: () => onTapLoginWithFacebook(),
                  onTapLoginWithGoogle: () => onTapLoginWithGoogle(),
                  emailController: emailController,
                  passwordController: passwordController,
                ),
                SignInSectionView(
                  userNameController: userNameController,
                  emailController: emailController,
                  phoneController: phoneController,
                  passwordController: passwordController,
                  onTapConfirm: onTapRegisterButton,
                  onTapRegisterWithFacebook: onTapRegisterWithFacebook,
                  onTapRegisterWithGoogle: onTapRegisterWithGoogle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabsView extends StatelessWidget {
  final List<String> tabs;

  const TabsView(
    this.tabs,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      child: TabBar(
        indicatorWeight: TAB_INDICATOR_SIZE,
        unselectedLabelColor: Colors.black54,
        labelColor: PRIMARY_COLOR,
        labelStyle: TextStyle(
          fontSize: TEXT_REGULAR_2X,
          fontWeight: FontWeight.bold,
        ),
        indicatorColor: PRIMARY_COLOR,
        tabs: tabs
            .map(
              (text) => Tab(
                child: TabTextView(
                  text,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class TabTextView extends StatelessWidget {
  final String text;

  TabTextView(
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: TEXT_REGULAR_2X,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
