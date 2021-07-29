import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_ticket/data/models/authentication_model.dart';
import 'package:movie_ticket/data/models/authentication_model_impl.dart';
import 'package:movie_ticket/data/vos/cast_vo.dart';
import 'package:movie_ticket/data/vos/movie_seat_vo.dart';
import 'package:movie_ticket/data/vos/movie_vo.dart';
import 'package:movie_ticket/data/vos/payment_method_vo.dart';
import 'package:movie_ticket/data/vos/snack_vo.dart';
import 'package:movie_ticket/data/vos/transaction_vo.dart';
import 'package:movie_ticket/data/vos/user_vo.dart';
import 'package:movie_ticket/data/vos/card_vo.dart';
import 'package:movie_ticket/data/vos/time_slot_vo.dart';
import 'package:movie_ticket/data/vos/cinema_day_time_slot_vo.dart';
import 'package:movie_ticket/network/responses/authentication_response.dart';
import 'package:movie_ticket/pages/home_page.dart';
import 'package:movie_ticket/pages/start_up_page.dart';
import 'package:movie_ticket/persistence/hive_constants.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(AuthenticationResponseAdapter());
  Hive.registerAdapter(UserVOAdapter());
  Hive.registerAdapter(CardVOAdapter());
  Hive.registerAdapter(MovieVOAdapter());
  Hive.registerAdapter(CastVOAdapter());
  Hive.registerAdapter(CinemaDayTimeSlotVOAdapter());
  Hive.registerAdapter(TimeSlotVOAdapter());
  Hive.registerAdapter(MovieSeatVOAdapter());
  Hive.registerAdapter(SnackVOAdapter());
  Hive.registerAdapter(PaymentMethodVOAdapter());
  Hive.registerAdapter(TransactionVOAdapter());

  await Hive.openBox<AuthenticationResponse>(BOX_NAME_AUTH_RESPONSE);
  await Hive.openBox<MovieVO>(BOX_NAME_MOVIE_VO);
  await Hive.openBox<UserVO>(BOX_NAME_USER_VO);
  await Hive.openBox<CinemaDayTimeSlotVO>(BOX_NAME_CINEMA_DAY_TIME_SLOT_VO);
  await Hive.openBox<MovieSeatVO>(BOX_NAME_MOVIE_SEAT_VO);
  await Hive.openBox<SnackVO>(BOX_NAME_SNACK_VO);
  await Hive.openBox<PaymentMethodVO>(BOX_NAME_PAYMENT_METHOD_VO);
  await Hive.openBox<TransactionVO>(BOX_NAME_TRANSACTION_VO);
  await Hive.openBox<String>(BOX_NAME_TOKEN);
  await Hive.openBox<int>(BOX_NAME_MOVIE_ID);
  await Hive.openBox<MovieSeatVO>(BOX_NAME_SELECTED_MOVIE_SEAT);
  await Hive.openBox<SnackVO>(BOX_NAME_SELECTED_SNACK);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthenticationModel _mAuthModel = AuthenticationModelImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _mAuthModel.getTokenFromDatabase() == null
          ? StartUpPage()
          : HomePage(
              token: _mAuthModel.getTokenFromDatabase()!,
            ),
    );
  }
}
