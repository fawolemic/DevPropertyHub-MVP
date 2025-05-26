import 'package:dio/dio.dart';'

class EmailVerificationApi {
  final Dio _dio;

  EmailVerificationApi([Dio? dio]) : _dio = dio ?? Dio();

  /// Verifies the email verification code with the backend.
  /// Returns true if the code is valid, false otherwise.
  Future<bool> verifyCode({required String email, required String code}) async {
    try {
      final response = await _dio.post(
        'https://your-backend-url.com/api/auth/verify-email',
        data: {
          'email': email,
          'code': code,
        },
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      // Optionally log error
      return false;
    }
  }
}
