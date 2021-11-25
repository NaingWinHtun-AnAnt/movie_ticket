import 'package:movie_ticket/network/responses/authentication_response.dart';
import 'package:movie_ticket/network/responses/log_out_response.dart';

abstract class AuthenticationModel {
  Future<AuthenticationResponse?>? registerWithEmail(
    String name,
    String email,
    String phone,
    String password,
    String googleAccessToken,
    String facebookAccessToken,
  );

  Future<AuthenticationResponse?>? loginWithEmail(String email, String password);

  Future<AuthenticationResponse?>? loginWithFacebook(String facebookAccessToken);

  Future<AuthenticationResponse?>? loginWithGoogle(String googleAccessToken);

  Future<LogOutResponse?>? logout(String token);

  /// from database
  String getTokenFromDatabase();

  void clearAuthenticationFromDatabase();
}
