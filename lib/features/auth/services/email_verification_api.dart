import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class EmailVerificationApi {
  final Dio _dio;
  final bool _useMockForTesting;

  EmailVerificationApi({Dio? dio, bool useMockForTesting = true})
      : _dio = dio ?? Dio(),
        _useMockForTesting = useMockForTesting;

  /// Verifies the email verification code with the backend.
  /// Returns true if the code is valid, false otherwise.
  Future<bool> verifyCode({required String email, required String code}) async {
    // For testing purposes, accept the test code without making an API call
    if (_useMockForTesting) {
      // Test code is '123456' as shown in the UI
      if (code == '123456') {
        debugPrint('Mock verification successful for $email with code $code');
        return true;
      }
      debugPrint('Mock verification failed for $email with code $code');
      return false;
    }

    // Real API implementation for production
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
      debugPrint('API error during email verification: $e');
      return false;
    }
  }
}
