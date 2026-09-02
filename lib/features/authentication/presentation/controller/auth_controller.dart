import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../auth_service.dart';
import '../../data/user_model.dart';

/// AuthController wires every authentication screen to the real backend.
///
/// Flow overview
/// ─────────────
/// Register  → verifyOtp(register) → Login → [subscripFirstPage]
/// ForgotPW  → verifyOtp(forgot)   → ResetPassword → [signInScreen]
class AuthController extends GetxController {
  // ─── Dependencies ────────────────────────────────────────────────────────

  final AuthService _authService = AuthService();
  late final StorageService _storage;

  @override
  void onInit() {
    super.onInit();
    _storage = Get.find<StorageService>();
  }

  // ─── Shared ──────────────────────────────────────────────────────────────

  /// Temporary token passed between steps (register → OTP, forgot → OTP etc.)
  final RxString _tempToken = ''.obs;

  String get tempToken => _tempToken.value;

  // Stores the currently authenticated user after login
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // ─── Error Banner ─────────────────────────────────────────────────────────

  /// Set by each action; shown as a SnackBar and cleared before next attempt.
  final RxString errorMessage = ''.obs;

  void _showError(String msg) {
    errorMessage.value = msg;
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: const Color(0xFF3A1010),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
    );
  }

  void _showSuccess(String msg) {
    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
    Get.snackbar(
      'Success',
      msg,
      backgroundColor: const Color(0xFF0F3A1A),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent),
    );
  }

  String _friendlyError(AppException e) {
    if (e is NoInternetException) return 'No internet. Please check your connection.';
    if (e is TimeoutException) return 'Request timed out. Try again.';
    return e.message;
  }

  // ─── Form Keys ────────────────────────────────────────────────────────────

  final formKey = GlobalKey<FormState>();
  final verificationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  // ─── REGISTER ─────────────────────────────────────────────────────────────

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxBool isRegisterLoading = false.obs;

  Future<void> onRegisterPressed() async {
    if (!registerFormKey.currentState!.validate()) return;
    errorMessage.value = '';
    isRegisterLoading.value = true;

    try {
      final token = await _authService.register(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      _tempToken.value = token;
      // Navigate to OTP screen for registration verification
      Get.toNamed(AppRoutes.verificationScreen, arguments: {'flow': 'register'});
    } on AppException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError('Unexpected error. Please try again.');
    } finally {
      isRegisterLoading.value = false;
    }
  }

  // ─── SIGN IN ──────────────────────────────────────────────────────────────

  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController = TextEditingController();
  final RxBool rememberMe = false.obs;
  final RxBool isSignInLoading = false.obs;

  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;

  Future<void> onSignInPressed(GlobalKey<FormState> signInFormKey) async {
    if (!signInFormKey.currentState!.validate()) return;
    errorMessage.value = '';
    isSignInLoading.value = true;

    try {
      final result = await _authService.login(
        email: signInEmailController.text.trim(),
        password: signInPasswordController.text,
      );

      // Persist credentials
      await _storage.setString(StorageKeys.authToken, result.token);
      await _storage.setBool(StorageKeys.isLoggedIn, true);
      await _storage.setString(StorageKeys.userId, result.user.id);
      await _storage.setString(StorageKeys.userEmail, result.user.email);
      await _storage.setString(
          StorageKeys.userName, result.user.displayName);

      currentUser.value = result.user;

      _showSuccess('Welcome back, ${result.user.displayName}!');

      // Skip subscription gate when user already has an active/trial plan
      final status = result.user.subscriptionStatus.toLowerCase();
      final hasActiveSub = status == 'active' || status == 'trial';
      Get.offAllNamed(
        hasActiveSub ? AppRoutes.bottomNavScreen : AppRoutes.subscripFirstPage,
      );
    } on AppException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError('Unexpected error. Please try again.');
    } finally {
      isSignInLoading.value = false;
    }
  }

  void onGoogleSignIn() {
    // TODO: Google sign in
    debugPrint('Google sign in tapped');
  }

  void onAppleSignIn() {
    // TODO: Apple sign in
    debugPrint('Apple sign in tapped');
  }

  // ─── FORGOT PASSWORD ──────────────────────────────────────────────────────

  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> onContinuePressed() async {
    if (!formKey.currentState!.validate()) return;
    errorMessage.value = '';
    isLoading.value = true;

    try {
      final token = await _authService.forgotPassword(
        email: emailController.text.trim(),
      );
      _tempToken.value = token;
      _showSuccess('OTP sent to your email!');
      Get.toNamed(AppRoutes.verificationScreen, arguments: {'flow': 'forgot'});
    } on AppException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError('Unexpected error. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── VERIFICATION (OTP) ───────────────────────────────────────────────────

  final TextEditingController otpController = TextEditingController();
  final RxString otpErrorText = ''.obs;
  final RxBool isVerifying = false.obs;

  Future<void> verificationCode(String code) async {
    if (code.trim().isEmpty) {
      otpErrorText.value = 'Please enter the verification code';
      return;
    }
    if (code.trim().length < 6) {
      otpErrorText.value = 'Please enter all 6 digits';
      return;
    }
    otpErrorText.value = '';
    isVerifying.value = true;

    // Determine which OTP flow we are in (register vs forgot-password)
    final args = Get.arguments as Map<String, dynamic>?;
    final flow = args?['flow'] as String? ?? 'register';

    try {
      if (flow == 'forgot') {
        // Verify forgot-password OTP → get verifyForgot token
        final verifyToken = await _authService.verifyForgotOtp(
          otp: code.trim(),
          forgotToken: _tempToken.value,
        );
        _tempToken.value = verifyToken;
        Get.toNamed(AppRoutes.resetPassScreen);
      } else {
        // Verify registration OTP
        await _authService.verifyOtp(
          otp: code.trim(),
          tempToken: _tempToken.value,
        );
        _showSuccess('Email verified! Please log in.');
        Get.offAllNamed(AppRoutes.signInScreen);
      }
    } on AppException catch (e) {
      otpErrorText.value = _friendlyError(e);
    } catch (e) {
      otpErrorText.value = 'Unexpected error. Please try again.';
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> resendCode() async {
    if (_tempToken.value.isEmpty) {
      _showError('Session expired. Please start again.');
      return;
    }
    otpController.clear();
    otpErrorText.value = '';

    try {
      final newToken = await _authService.resendOtp(tempToken: _tempToken.value);
      _tempToken.value = newToken;
      _showSuccess('A new OTP has been sent to your email.');
    } on AppException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError('Failed to resend OTP. Please try again.');
    }
  }

  // ─── RESET PASSWORD ───────────────────────────────────────────────────────

  final TextEditingController resetPass = TextEditingController();
  final TextEditingController resetConformPass = TextEditingController();
  final RxBool isResetLoading = false.obs;

  Future<void> resetPassword(GlobalKey<FormState> resetPassFormKey) async {
    if (!resetPassFormKey.currentState!.validate()) return;
    errorMessage.value = '';
    isResetLoading.value = true;

    try {
      await _authService.resetPassword(
        password: resetPass.text,
        confirmPassword: resetConformPass.text,
        verifyForgotToken: _tempToken.value,
      );
      _tempToken.value = '';
      resetPass.clear();
      resetConformPass.clear();
      _showSuccess('Password reset successfully! Please log in.');
      Get.offAllNamed(AppRoutes.signInScreen);
    } on AppException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError('Unexpected error. Please try again.');
    } finally {
      isResetLoading.value = false;
    }
  }

  // ─── SIGN OUT ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _storage.remove(StorageKeys.authToken);
    await _storage.remove(StorageKeys.refreshToken);
    await _storage.setBool(StorageKeys.isLoggedIn, false);
    currentUser.value = null;
    _tempToken.value = '';
    Get.offAllNamed(AppRoutes.signInScreen);

    // Deferred so the tab widgets are unmounted before their controllers go.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DependencyInjection.clearSessionControllers();
    });
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  bool get isLoggedIn => _storage.getBool(StorageKeys.isLoggedIn) ?? false;

  String? get authToken => _storage.getString(StorageKeys.authToken);

  // ─── DISPOSE ──────────────────────────────────────────────────────────────

  @override
  void onClose() {
    emailController.dispose();
    resetPass.dispose();
    resetConformPass.dispose();
    otpController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    signInEmailController.dispose();
    signInPasswordController.dispose();
    super.onClose();
  }
}
