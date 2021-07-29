/// base urls
const BASE_URL = "https://tmba.padc.com.mm";
const IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w300";

/// end points
const END_POINT_REGISTER_WITH_EMAIL = "/api/v1/register";
const END_POINT_LOGIN_WITH_EMAIL = "/api/v1/email-login";
const END_POINT_LOGIN_WITH_GOOGLE = "/api/v1/google-login";
const END_POINT_LOGIN_WITH_FACEBOOK = "/api/v1/facebook-login";
const END_POINT_GET_MOVIE_LIST = "/api/v1/movies";
const END_POINT_GET_CINEMA_LIST = "/api/v1/cinemas";
const END_POINT_GET_MOVIE_DETAIL_BY_ID = "/api/v1/movies";
const END_POINT_GET_PROFILE = "/api/v1/profile";
const END_POINT_LOGOUT = "/api/v1/logout";
const END_POINT_GET_SNACK = "/api/v1/snacks";
const END_POINT_GET_PAYMENT_METHODS = "/api/v1/payment-methods";
const END_POINT_GET_SEAT_PLAN = "/api/v1/seat-plan";
const END_POINT_GET_CINEMA_DAY_TIMESLOT = "/api/v1/cinema-day-timeslots";
const END_POINT_CREATE_CARD = "/api/v1/card";
const END_POINT_GET_PROFILE_TRANSACTION = "/api/v1/profile/transactions";
const END_POINT_CHECK_OUT = "/api/v1/checkout";

/// parameters
const PARAM_NAME = "name";
const PARAM_EMAIL = "email";
const PARAM_PHONE = "phone";
const PARAM_PASSWORD = "password";
const PARAM_GOOGLE_ACCESS_TOKEN = "google-access-token";
const PARAM_FACEBOOK_ACCESS_TOKEN = "facebook-access-token";
const PARAM_ACCESS_TOKEN = "access-token";
const PARAM_STATUS = "status";
const PARAM_ACCEPT = "Accept";
const PARAM_AUTHORIZATION = "Authorization";
const PARAM_CINEMA_DAY_TIMESLOT_ID = "cinema_day_timeslot_id";
const PARAM_BOOKING_DATE = "booking_date";
const PARAM_DATE = "date";
const PARAM_CARD_NUMBER = "card_number";
const PARAM_CARD_HOLDER = "card_holder";
const PARAM_EXPIRATION_DATE = "expiration_date";
const PARAM_CVC = "cvc";

/// const values
const ACCEPT = "application/json";
const NOW_SHOWING = "nowshowing";
const COMING_SOON = "comingsoon";

/// response code
const RESPONSE_CODE_SUCCESS = 200;
