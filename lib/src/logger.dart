import 'dart:developer';

class ApiLogger {
  static void logRequest(String method, String url, dynamic data, dynamic headers) {
    log('📤 [$method] $url\nHeaders: $headers\nBody: $data');
  }

  static void logResponse(dynamic data, int? statusCode) {
    log('📥 Response ($statusCode): $data');
  }

  static void logError(dynamic error) {
    log('❌ Error: $error');
  }
}
