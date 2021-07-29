import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/network/agents/movie_ticket_data_agent.dart';
import 'package:movie_ticket/network/agents/retrofit_data_agent_impl.dart';
import 'package:movie_ticket/network/responses/authentication_response.dart';
import 'package:movie_ticket/network/responses/log_out_response.dart';
import 'package:movie_ticket/persistence/daos/authentication_dao.dart';
import 'package:movie_ticket/persistence/daos/user_dao.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  MovieTicketDataAgent _mDataAgent = RetrofitDataAgentImpl();

  static final AuthenticationModelImpl _singleton =
      AuthenticationModelImpl._internal();

  factory AuthenticationModelImpl() => _singleton;

  AuthenticationModelImpl._internal();

  /// daos
  AuthenticationDao _authDao = AuthenticationDao();
  UserDao _userDao = UserDao();

  /// register, login and logout
  @override
  Future<AuthenticationResponse> registerWithEmail(
    String name,
    String email,
    String phone,
    String password,
    String googleAccessToken,
    String facebookAccessToken,
  ) {
    return _mDataAgent
        .registerWithEmail(
      name,
      email,
      phone,
      password,
      googleAccessToken,
      facebookAccessToken,
    )
        .then((value) {
      if (value.token != null) {
        _authDao.saveToken(value.token!);
        _userDao.saveUserVO(value.data!);
      }
      return Future.value(value);
    });
  }

  @override
  Future<AuthenticationResponse> loginWithEmail(
    String email,
    String password,
  ) {
    return _mDataAgent.loginWithEmail(email, password).then((value) {
      if (value.token != null) {
        _authDao.saveToken(value.token!);
        _userDao.saveUserVO(value.data!);
      }
      return Future.value(value);
    });
  }

  @override
  Future<AuthenticationResponse> loginWithFacebook(String facebookAccessToken) {
    return _mDataAgent.loginWithFacebook(facebookAccessToken).then((value) {
      if (value.token != null) {
        _authDao.saveToken(value.token!);
        _userDao.saveUserVO(value.data!);
      }
      return Future.value(value);
    });
  }

  @override
  Future<AuthenticationResponse> loginWithGoogle(String accessToken) {
    return _mDataAgent.loginWithGoogle(accessToken).then((value) {
      if (value.token != null) {
        _authDao.saveToken(value.token!);
        _userDao.saveUserVO(value.data!);
      }
      return Future.value(value);
    });
  }

  @override
  Future<LogOutResponse> logout(String token) {
    return _mDataAgent.logout(token);
  }

  /// from database
  @override
  String? getTokenFromDatabase() {
    return _authDao.getToken();
  }

  @override
  void clearAuthenticationFromDatabase() {
    _authDao.clear();
  }
}
