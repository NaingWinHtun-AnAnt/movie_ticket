import 'package:dio/dio.dart';
import 'package:movie_ticket/network/requests/check_out_request.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/data/vos/cinema_vo.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';
import 'package:movie_ticket/data/vos/snack_vo.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';
import 'package:movie_ticket/network/agents/movie_ticket_data_agent.dart';
import 'package:movie_ticket/network/api_constants.dart';
import 'package:movie_ticket/network/responses/authentication_response.dart';
import 'package:movie_ticket/network/responses/check_out_response.dart';
import 'package:movie_ticket/network/responses/create_card_response.dart';
import 'package:movie_ticket/network/responses/log_out_response.dart';
import 'package:movie_ticket/network/the_movie_ticket_api.dart';

class RetrofitDataAgentImpl extends MovieTicketDataAgent {
  late TheMovieTicketApi _mApi;
  static final RetrofitDataAgentImpl _singleton =
      RetrofitDataAgentImpl._internal();

  factory RetrofitDataAgentImpl() => _singleton;

  RetrofitDataAgentImpl._internal() {
    final dio = Dio();
    dio.options = BaseOptions(headers: {
      PARAM_ACCEPT: ACCEPT,
    });
    _mApi = TheMovieTicketApi(dio);
  }

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
    return _mApi
        .registerWithEmail(
      name,
      email,
      phone,
      password,
      googleAccessToken,
      facebookAccessToken,
    )
        .then((response) {
      if (response.code == RESPONSE_CODE_SUCCESS) {
        return Future.value(response);
      } else {
        return Future.error(response.message);
      }
    });
  }

  @override
  Future<AuthenticationResponse> loginWithEmail(
    String email,
    String password,
  ) {
    return _mApi.logInWithEmail(email, password).then((response) {
      if (response.code == RESPONSE_CODE_SUCCESS) {
        return Future.value(response);
      } else {
        return Future.error(response.message);
      }
    });
  }

  @override
  Future<AuthenticationResponse> loginWithFacebook(String accessToken) {
    return _mApi.logInWithFacebook(accessToken);
  }

  @override
  Future<AuthenticationResponse> loginWithGoogle(String accessToken) {
    return _mApi.logInWithGoogle(accessToken);
  }

  @override
  Future<LogOutResponse> logout(String token) {
    return _mApi.logout(token).asStream().map((event) => event).first;
  }

  /// get cinema list, movie list and detail
  @override
  Future<List<MovieVO>> getMovieList(String status) {
    return _mApi
        .getMovieList(status)
        .asStream()
        .map((event) => event.data)
        .first;
  }

  @override
  Future<List<CinemaVO>> getCinemaList() {
    return _mApi.getCinemaList().asStream().map((event) => event.data).first;
  }

  @override
  Future<MovieVO> getMovieDetailById(int movieId) {
    return _mApi
        .getMovieDetailById(movieId)
        .asStream()
        .map((event) => event.data)
        .first;
  }

  /// auth api
  @override
  Future<UserVO> getUserProfile(String token
      ) {
    return _mApi
        .getUserProfile(token)
        .asStream()
        .map((event) => event.data)
        .first;
  }

  @override
  Future<List<SnackVO>> getSnacks(String token) {
    return _mApi.getSnacks(token).asStream().map((event) => event.data).first;
  }

  @override
  Future<List<List<MovieSeatVO>>> getSeatPlan(
      String token, int id, String bookingDate) {
    return _mApi
        .getSeatPlan(token, id, bookingDate)
        .asStream()
        .map((event) => event.data)
        .first;
  }

  @override
  Future<List<CinemaDayTimeSlotVO>> getCinemaDayTimeSlots(
      String token, String date) {
    return _mApi
        .getCinemaDayTimeSlots(token, date)
        .asStream()
        .map((event) => event.data)
        .first;
  }

  @override
  Future<CreateCardResponse> createCard(String token, String cardNumber,
      String cardHolder, String expirationDate, String cvc) {
    return _mApi
        .createCard(token, cardNumber, cardHolder, expirationDate, cvc)
        .asStream()
        .map((event) => event)
        .first;
  }

  @override
  Future<List<PaymentMethodVO>> getPaymentMethod(String token) {
    return _mApi
        .getPaymentMethod(token)
        .asStream()
        .map((event) => event.data)
        .first;
  }

  @override
  Future<List<TransactionVO>> getProfileTransaction(String token) {
    return _mApi
        .getProfileTransaction(token)
        .asStream()
        .map((event) => event.data)
        .first;
  }

  @override
  Future<TransactionVO?> checkOut(String token, CheckOutRequest checkOut) {
    return _mApi
        .checkOut(token, checkOut)
        .then((response) {
          if (response.code == RESPONSE_CODE_SUCCESS) {
            return Future<CheckOutResponse>.value(response);
          } else {
            return Future<CheckOutResponse>.error(response.message);
          }
        })
        .asStream()
        .map((event) {
          return event.data;
        })
        .first;
  }
}
