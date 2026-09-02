import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import 'data/user_model.dart';

/// Handles all authentication-related HTTP calls.
///
/// Each method maps 1-to-1 to a backend endpoint defined in [ApiEndpoints].
/// The raw [ApiService] is used for the HTTP layer; token persistence is
/// handled in [AuthController] (which uses [StorageService]).
class AuthService {
  final ApiService _api;

  AuthService({ApiService? apiService}) : _api = apiService ?? ApiService();

  // ──────────────────────────────────────────────────────────────────────────
  // 1. REGISTER
  // POST /api/v1/user/register
  // Body: { firstName, lastName, email, password, confirmPassword }
  // Response: { data: { token } }  — temporary token for OTP step
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _api.post(
      ApiEndpoints.register,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    _assertSuccess(response.data, 'Registration failed.');
    final token = response.data['data']?['token'] as String?;
    if (token == null || token.isEmpty) {
      throw ServerException('No token returned from server.', null);
    }
    return token;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. VERIFY OTP  (registration flow)
  // POST /api/v1/user/verify-otp
  // Header: Authorization: Bearer <register-token>
  // Body:   { otp }
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> verifyOtp({
    required String otp,
    required String tempToken,
  }) async {
    final response = await _api.postWithToken(
      ApiEndpoints.verifyOtp,
      token: tempToken,
      data: {'otp': otp},
    );
    _assertSuccess(response.data, 'OTP verification failed.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. LOGIN
  // POST /api/v1/user/login
  // Body: { email, password }
  // Response: { data: { user: {...}, token: "..." } }
  // ──────────────────────────────────────────────────────────────────────────
  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    _assertSuccess(response.data, 'Login failed.');
    final dataMap = response.data['data'] as Map<String, dynamic>?;
    final userMap = dataMap?['user'] as Map<String, dynamic>?;
    final token = dataMap?['token'] as String?;
    if (userMap == null || token == null || token.isEmpty) {
      throw ServerException('Invalid login response from server.', null);
    }
    return (user: UserModel.fromJson(userMap), token: token);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. FORGOT PASSWORD
  // POST /api/v1/user/forgot-password
  // Body: { email }
  // Response: { data: { token } }  — forgot-password token
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> forgotPassword({required String email}) async {
    final response = await _api.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    _assertSuccess(response.data, 'Failed to send reset email.');
    final token = response.data['data']?['token'] as String?;
    if (token == null || token.isEmpty) {
      throw ServerException('No token returned from server.', null);
    }
    return token;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 5. VERIFY FORGOT-PASSWORD OTP
  // POST /api/v1/user/verify-forgot-otp
  // Header: Authorization: Bearer <forgot-token>
  // Body:   { otp }
  // Response: { data: { token } }  — verifyForgot token
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> verifyForgotOtp({
    required String otp,
    required String forgotToken,
  }) async {
    final response = await _api.postWithToken(
      ApiEndpoints.verifyForgotOtp,
      token: forgotToken,
      data: {'otp': otp},
    );
    _assertSuccess(response.data, 'OTP verification failed.');
    final token = response.data['data']?['token'] as String?;
    if (token == null || token.isEmpty) {
      throw ServerException('No token returned from server.', null);
    }
    return token;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 6. RESEND OTP
  // POST /api/v1/user/resend-otp
  // Header: Authorization: Bearer <register-token | forgot-token>
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> resendOtp({required String tempToken}) async {
    final response = await _api.postWithToken(
      ApiEndpoints.resendOtp,
      token: tempToken,
    );
    _assertSuccess(response.data, 'Failed to resend OTP.');
    // Backend returns a refreshed token
    final token = response.data['data']?['token'] as String?;
    return token ?? tempToken; // fall back to existing token if not refreshed
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 7. RESET PASSWORD
  // POST /api/v1/user/reset-password
  // Header: Authorization: Bearer <verifyForgot-token>
  // Body:   { password, confirmPassword }
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> resetPassword({
    required String password,
    required String confirmPassword,
    required String verifyForgotToken,
  }) async {
    final response = await _api.postWithToken(
      ApiEndpoints.resetPassword,
      token: verifyForgotToken,
      data: {'password': password, 'confirmPassword': confirmPassword},
    );
    _assertSuccess(response.data, 'Password reset failed.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 8. MY PROFILE  (requires auth token stored in StorageService)
  // GET /api/v1/user/my-profile
  // ──────────────────────────────────────────────────────────────────────────
  Future<UserModel> myProfile() async {
    final response = await _api.get(ApiEndpoints.myProfile);
    _assertSuccess(response.data, 'Failed to fetch profile.');
    final userMap = response.data['data'] as Map<String, dynamic>?;
    if (userMap == null) {
      throw ServerException('Invalid profile response.', null);
    }
    return UserModel.fromJson(userMap);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 9. UPDATE PROFILE  (requires auth token)
  // PATCH /api/v1/user/update-profile
  // Body: { name?, firstName?, lastName?, phone?, address? }
  // ──────────────────────────────────────────────────────────────────────────
  Future<UserModel> updateProfile({
    String? name,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };
    final response = await _api.patch(
      ApiEndpoints.updateProfile,
      data: body,
    );
    _assertSuccess(response.data, 'Failed to update profile.');
    final userMap = response.data['data'] as Map<String, dynamic>?;
    if (userMap == null) {
      throw ServerException('Invalid update-profile response.', null);
    }
    return UserModel.fromJson(userMap);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 10. CHANGE PASSWORD  (requires auth token)
  // POST /api/v1/user/change-password
  // Body: { oldPassword, newPassword, confirmPassword }
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _api.post(
      ApiEndpoints.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    _assertSuccess(response.data, 'Failed to change password.');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helper: assert the server returned success:true
  // ──────────────────────────────────────────────────────────────────────────
  void _assertSuccess(dynamic responseData, String fallbackMessage) {
    if (responseData is Map<String, dynamic>) {
      final success = responseData['success'];
      if (success == false) {
        final msg = responseData['message'] as String?;
        throw ServerException(msg?.isNotEmpty == true ? msg! : fallbackMessage, null);
      }
    }
  }
}
