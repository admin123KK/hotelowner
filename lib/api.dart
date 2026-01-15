class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "https://demo.beyondtechnepal.com/api";

  static const String loginEndPoint = "$baseUrl/login";
  static const String logoutEndPoint = "$baseUrl/logout";
  static const String latestPaymentEndPoint = "$baseUrl/ongoing-payment";
  static const String revenueDayEndPoint = "$baseUrl/today-revenue";
  static const String dailyroomDetailsEndPoint =
      "$baseUrl/rooms-summary?start_date={{value}}&end_date={{value}}";
  static const String roomTypesEndPoint =
      "$baseUrl/room-types?start_date={{value}}&end_date={{value}}";
}
