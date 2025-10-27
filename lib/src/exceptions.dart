import 'dart:io';
import 'package:dio/dio.dart';

/// Custom exception handler for API calls
class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => 'ApiException($code): $message';

  /// Converts Dio errors and other exceptions into readable messages
  static ApiException from(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException('⏱ Connection timeout. Please try again.', code: 408);

        case DioExceptionType.sendTimeout:
          return ApiException('📡 Send timeout. Please check your connection.', code: 408);

        case DioExceptionType.receiveTimeout:
          return ApiException('⌛ Receive timeout. Please try again later.', code: 504);

        case DioExceptionType.badResponse:
          return ApiException(
            _handleBadResponse(error.response),
            code: error.response?.statusCode,
          );

        case DioExceptionType.cancel:
          return ApiException('❌ Request cancelled.', code: 499);

        case DioExceptionType.connectionError:
          return ApiException('🌐 Network connection failed. Check your internet.', code: 503);

        default:
          return ApiException('⚠️ Unexpected error occurred.', code: 500);
      }
    } else if (error is SocketException) {
      return ApiException('📴 No internet connection.', code: 503);
    } else if (error is HttpException) {
      return ApiException('🚫 Invalid HTTP response.', code: 502);
    } else if (error is FormatException) {
      return ApiException('💥 Bad response format.', code: 500);
    } else {
      return ApiException('😵 Something went wrong: $error', code: 500);
    }
  }

  /// Helper to parse server error responses nicely
  static String _handleBadResponse(Response? response) {
    final status = response?.statusCode ?? 0;
    final data = response?.data;

    switch (status) {
      case 400:
        return '⚠️ Bad request. Please check your input.';
      case 401:
        return '🔒 Unauthorized. Please login again.';
      case 403:
        return '🚫 Access forbidden.';
      case 404:
        return '❓ Resource not found.';
      case 409:
        return '⚠️ Conflict error.';
      case 422:
        return '⚙️ Validation failed: ${data?['message'] ?? ''}';
      case 500:
        return '💥 Server error. Please try later.';
      case 503:
        return '🛠 Server unavailable.';
      default:
        return '⚠️ Error $status: ${data?['message'] ?? 'Unknown error'}';
    }
  }
}
