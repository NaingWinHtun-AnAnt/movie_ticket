import 'package:movie_ticket/network/requests/check_out_request.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/data/vos/cinema_vo.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';
import 'package:movie_ticket/data/vos/snack_vo.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';
import 'package:movie_ticket/network/responses/authentication_response.dart';
import 'package:movie_ticket/network/responses/create_card_response.dart';
import 'package:movie_ticket/network/responses/log_out_response.dart';

abstract class MovieTicketDataAgent {
  /// register, login and logout
  Future<AuthenticationResponse> registerWithEmail(
    String name,
    String email,
    String phone,
    String password,
    String googleAccessToken,
    String facebookAccessToken,
  );

  Future<AuthenticationResponse> loginWithEmail(
    String email,
    String password,
  );

  Future<AuthenticationResponse> loginWithFacebook(
    String accessToken,
  );

  Future<AuthenticationResponse> loginWithGoogle(
    String accessToken,
  );

  Future<LogOutResponse> logout(String token);

  /// get cinema list, movie list and detail
  Future<List<MovieVO>> getMovieList(String status);

  Future<List<CinemaVO>> getCinemaList();

  Future<MovieVO> getMovieDetailById(int movieId);

  /// auth api
  Future<UserVO> getUserProfile(String token,);

  Future<List<SnackVO>> getSnacks(String token);

  Future<List<List<MovieSeatVO>>> getSeatPlan(
      String token, int id, String bookingDate);

  Future<List<CinemaDayTimeSlotVO>> getCinemaDayTimeSlots(
      String token, String date);

  Future<CreateCardResponse> createCard(String token, String cardNumber,
      String cardHolder, String expirationDate, String cvc);

  Future<List<PaymentMethodVO>> getPaymentMethod(String token);

  Future<List<TransactionVO>> getProfileTransaction(String token);

  Future<TransactionVO?> checkOut(String token, CheckOutRequest checkOutVO);
}
