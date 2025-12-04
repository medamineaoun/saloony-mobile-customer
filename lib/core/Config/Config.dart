class Config {
  static const String ipAddressAndPort = 'localhost:8081';
  static const String baseUrl = 'http://$ipAddressAndPort';
  static const String authBaseUrl = '$baseUrl/api/v1/auth';
  static const String userBaseUrl = '$baseUrl/api/v1/auth/user';
  static const String salonBaseUrl = '$baseUrl/api/salon';
  static const String apisalon = '$baseUrl/api/salon/';
  static const String treatmentBaseUrl = '$baseUrl/api/treatment';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const int minPasswordLength = 6;
  static const int verificationCodeLength = 6;
  static const int codeExpirationMinutes = 15;
  static const int minSalonNameLength = 2;
  static const int maxSalonNameLength = 100;
  static const int maxSalonDescriptionLength = 500;
}
