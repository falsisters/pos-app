import "package:flutter_dotenv/flutter_dotenv.dart";

class ApiConstants {
  static String baseUrl = dotenv.get('API_URL');
  static String loginEndpoint = '/cashier';
  static String cashierInfoEndpoint = '/cashier/info';
}
