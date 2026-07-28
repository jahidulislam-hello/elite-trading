import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final verificationFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
      Get.toNamed(AppRoutes.verificationScreen);
    }
  }

  //------------------Register Screen----------------------------
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxBool isRegisterLoading = false.obs;

  void onRegisterPressed() {
    if (registerFormKey.currentState!.validate()) {
      if (registerPasswordController.text != confirmPasswordController.text) {
       Get.offAllNamed(AppRoutes.subscripFirstPage);
      }
      isRegisterLoading.value = true;
      print("Register: ${registerEmailController.text}");
      // TODO: call register API
      isRegisterLoading.value = false;
    }
  }

  //------------------Sign In Screen----------------------------
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController = TextEditingController();
  final RxBool rememberMe = false.obs;
  final RxBool isSignInLoading = false.obs;

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void onSignInPressed() {
    if (signInFormKey.currentState!.validate()) {
      isSignInLoading.value = true;
     Get.offAllNamed(AppRoutes.subscripFirstPage);
      isSignInLoading.value = false;
    }
  }

  void onGoogleSignIn() {
    print("Google sign in tapped");
    // TODO: Google sign in
  }

  void onAppleSignIn() {
    print("Apple sign in tapped");
    // TODO: Apple sign in
  }

  //------------------reset Password Screen----------------------------
  final TextEditingController resetPass = TextEditingController();
  final resetPassFormKey = GlobalKey<FormState>();
  final TextEditingController resetConformPass = TextEditingController();

  void resetPassword() {
    if (resetPassFormKey.currentState!.validate()) {
      Get.toNamed(AppRoutes.signInScreen);
    }
  }

  //------------------Verification Screen----------------------------
  final TextEditingController otpController = TextEditingController();
  final RxString otpErrorText = ''.obs;
  final RxBool isVerifying = false.obs;

  void verificationCode(String code) {
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

    Get.toNamed(AppRoutes.resetPassScreen);

    isVerifying.value = false;
  }

  void resendCode() {
    otpController.clear();
    otpErrorText.value = '';
    // TODO: call resend OTP API
    print("Resending code...");
  }

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
    super.onClose();
  }
}