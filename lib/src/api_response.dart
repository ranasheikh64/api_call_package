class ApiResponse<T> {
  final bool success;
  final int? statusCode;
  final String? message;
  final T? data;

  ApiResponse({
    required this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ApiResponse.success(T data, {int? code}) => ApiResponse(
        success: true,
        statusCode: code,
        data: data,
      );

  factory ApiResponse.error(String message, {int? code}) => ApiResponse(
        success: false,
        statusCode: code,
        message: message,
      );
}
