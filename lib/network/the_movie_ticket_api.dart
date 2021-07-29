import 'package:dio/dio.dart';
import 'package:movie_ticket/network/requests/check_out_request.dart';
import 'package:movie_ticket/network/api_constants.dart';
import 'package:movie_ticket/network/responses/authentication_response.dart';
import 'package:movie_ticket/network/responses/check_out_response.dart';
import 'package:movie_ticket/network/responses/cinema_day_timeslot_response.dart';
import 'package:movie_ticket/network/responses/cinema_list_response.dart';
import 'package:movie_ticket/network/responses/create_card_response.dart';
import 'package:movie_ticket/network/responses/log_out_response.dart';
import 'package:movie_ticket/network/responses/movie_detail_response.dart';
import 'package:movie_ticket/network/responses/movie_list_response.dart';
import 'package:movie_ticket/network/responses/payment_method_response.dart';
import 'package:movie_ticket/network/responses/profile_response.dart';
import 'package:movie_ticket/network/responses/profile_transaction_response.dart';
import 'package:movie_ticket/network/responses/seat_plan_response.dart';
import 'package:movie_ticket/network/responses/snack_response.dart';
import 'package:retrofit/http.dart';

part 'the_movie_ticket_api.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class TheMovieTicketApi {
  factory TheMovieTicketApi(Dio dio) = _TheMovieTicketApi;

  /// register, login, logout
  @POST(END_POINT_REGISTER_WITH_EMAIL)
  Future<AuthenticationResponse> registerWithEmail(
    @Field(PARAM_NAME) String name,
    @Field(PARAM_EMAIL) String email,
    @Field(PARAM_PHONE) String phone,
    @Field(PARAM_PASSWORD) String password,
    @Field(PARAM_GOOGLE_ACCESS_TOKEN) String googleAccessToken,
    @Field(PARAM_FACEBOOK_ACCESS_TOKEN) String facebookAccessToken,
  );

  @POST(END_POINT_LOGIN_WITH_EMAIL)
  Future<AuthenticationResponse> logInWithEmail(
    @Field(PARAM_EMAIL) String email,
    @Field(PARAM_PASSWORD) String password,
  );

  @POST(END_POINT_LOGIN_WITH_FACEBOOK)
  Future<AuthenticationResponse> logInWithFacebook(
    @Part(name: PARAM_ACCESS_TOKEN) String accessToken,
  );

  @POST(END_POINT_LOGIN_WITH_GOOGLE)
  Future<AuthenticationResponse> logInWithGoogle(
    @Part(name: PARAM_ACCESS_TOKEN) String accessToken,
  );

  @POST(END_POINT_LOGOUT)
  Future<LogOutResponse> logout(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  /// get cinema list, movie list, detail
  @GET(END_POINT_GET_CINEMA_LIST)
  Future<CinemaListResponse> getCinemaList();

  @GET(END_POINT_GET_MOVIE_LIST)
  Future<MovieListResponse> getMovieList(
    @Query(PARAM_STATUS) String status,
  );

  @GET("$END_POINT_GET_MOVIE_DETAIL_BY_ID/{movie_id}")
  Future<MovieDetailResponse> getMovieDetailById(
    @Path("movie_id") int movieId,
  );

  /// auth api
  @GET(END_POINT_GET_PROFILE)
  Future<ProfileResponse> getUserProfile(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @GET(END_POINT_GET_SNACK)
  Future<SnackResponse> getSnacks(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @GET(END_POINT_GET_SEAT_PLAN)
  Future<SeatPlanResponse> getSeatPlan(
    @Header(PARAM_AUTHORIZATION) String token,
    @Query(PARAM_CINEMA_DAY_TIMESLOT_ID) int id,
    @Query(PARAM_BOOKING_DATE) String bookingDate,
  );

  @GET(END_POINT_GET_CINEMA_DAY_TIMESLOT)
  Future<CinemaDayTimeSlotResponse> getCinemaDayTimeSlots(
    @Header(PARAM_AUTHORIZATION) String token,
    @Query(PARAM_DATE) String date,
  );

  @POST(END_POINT_CREATE_CARD)
  Future<CreateCardResponse> createCard(
    @Header(PARAM_AUTHORIZATION) String token,
    @Field(PARAM_CARD_NUMBER) String cardNumber,
    @Field(PARAM_CARD_HOLDER) String cardHolder,
    @Field(PARAM_EXPIRATION_DATE) String expirationDate,
    @Field(PARAM_CVC) String cvc,
  );

  @GET(END_POINT_GET_PAYMENT_METHODS)
  Future<PaymentMethodResponse> getPaymentMethod(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @GET(END_POINT_GET_PROFILE_TRANSACTION)
  Future<ProfileTransactionResponse> getProfileTransaction(
    @Header(PARAM_AUTHORIZATION) String token,
  );

  @POST(END_POINT_CHECK_OUT)
  Future<CheckOutResponse> checkOut(
    @Header(PARAM_AUTHORIZATION) String token,
    @Body() CheckOutRequest checkOutDetail,
  );
}
