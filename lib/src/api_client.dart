import 'package:dio/dio.dart';
import 'api_response.dart';
import 'logger.dart';
import 'exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    String? baseUrl,
    Map<String, dynamic>? headers,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? '',
          headers: headers,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  // 🔐 Token handler
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // 🌐 GET
  Future<ApiResponse> get(String url, {Map<String, dynamic>? query}) async {
    try {
      ApiLogger.logRequest('GET', url, query, _dio.options.headers);
      final response = await _dio.get(url, queryParameters: query);
      ApiLogger.logResponse(response.data, response.statusCode);
      return ApiResponse.success(response.data, code: response.statusCode);
    } catch (e) {
      final ex = ApiException.from(e);
      ApiLogger.logError(ex);
      return ApiResponse.error(ex.message, code: ex.code);
    }
  }

  // 📤 POST
  Future<ApiResponse> post(String url, {dynamic body}) async {
    try {
      ApiLogger.logRequest('POST', url, body, _dio.options.headers);
      final response = await _dio.post(url, data: body);
      ApiLogger.logResponse(response.data, response.statusCode);
      return ApiResponse.success(response.data, code: response.statusCode);
    } catch (e) {
      final ex = ApiException.from(e);
      ApiLogger.logError(ex);
      return ApiResponse.error(ex.message, code: ex.code);
    }
  }

  // 🧾 PUT
  Future<ApiResponse> put(String url, {dynamic body}) async {
    try {
      ApiLogger.logRequest('PUT', url, body, _dio.options.headers);
      final response = await _dio.put(url, data: body);
      ApiLogger.logResponse(response.data, response.statusCode);
      return ApiResponse.success(response.data, code: response.statusCode);
    } catch (e) {
      final ex = ApiException.from(e);
      ApiLogger.logError(ex);
      return ApiResponse.error(ex.message, code: ex.code);
    }
  }

  // ❌ DELETE
  Future<ApiResponse> delete(String url, {dynamic body}) async {
    try {
      ApiLogger.logRequest('DELETE', url, body, _dio.options.headers);
      final response = await _dio.delete(url, data: body);
      ApiLogger.logResponse(response.data, response.statusCode);
      return ApiResponse.success(response.data, code: response.statusCode);
    } catch (e) {
      final ex = ApiException.from(e);
      ApiLogger.logError(ex);
      return ApiResponse.error(ex.message, code: ex.code);
    }
  }

  // 🔄 PATCH
  Future<ApiResponse> patch(String url, {dynamic body}) async {
    try {
      ApiLogger.logRequest('PATCH', url, body, _dio.options.headers);
      final response = await _dio.patch(url, data: body);
      ApiLogger.logResponse(response.data, response.statusCode);
      return ApiResponse.success(response.data, code: response.statusCode);
    } catch (e) {
      final ex = ApiException.from(e);
      ApiLogger.logError(ex);
      return ApiResponse.error(ex.message, code: ex.code);
    }
  }

  // 📁 Multipart upload
  Future<ApiResponse> upload(
    String url, {
    required Map<String, dynamic> fields,
    required String fileKey,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...fields,
        fileKey: await MultipartFile.fromFile(filePath),
      });

      ApiLogger.logRequest('UPLOAD', url, formData.fields, _dio.options.headers);
      final response = await _dio.post(url, data: formData);
      ApiLogger.logResponse(response.data, response.statusCode);

      return ApiResponse.success(response.data, code: response.statusCode);
    } catch (e) {
      final ex = ApiException.from(e);
      ApiLogger.logError(ex);
      return ApiResponse.error(ex.message, code: ex.code);
    }
  }

  // 📥 File Download
  Future<ApiResponse> download(String url, String savePath) async {
    try {
      ApiLogger.logRequest('DOWNLOAD', url, null, _dio.options.headers);
      await _dio.download(url, savePath);
      ApiLogger.logResponse('File saved at $savePath', 200);
      return ApiResponse.success('Downloaded: $savePath', code: 200);
    } catch (e) {
      final ex = ApiException.from(e);
      ApiLogger.logError(ex);
      return ApiResponse.error(ex.message, code: ex.code);
    }
  }
}
