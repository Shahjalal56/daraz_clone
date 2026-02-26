import 'package:dio/dio.dart';

class ErrorHandler {
  ErrorHandler._();

  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please try again.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ??
              error.response?.data.toString();
          return 'Server error ($statusCode): $message';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return 'An unexpected error occurred.';
      }
    }
    return error?.toString() ?? 'An unknown error occurred.';
  }
}
