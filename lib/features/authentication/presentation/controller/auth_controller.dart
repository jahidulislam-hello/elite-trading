import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final RxBool isLoading = false.obs;

  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
      print("Reset link sent to: ${emailController.text}");
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
        Get.snackbar("Error", "Passwords do not match");
        return;
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
      print("Login: ${signInEmailController.text}");
      // TODO: call login API
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
  final TextEditingController resetConformPass = TextEditingController();

  void resetPassword(GlobalKey<FormState> resetFormKey) {
    if (resetFormKey.currentState!.validate()) {
      print("Reset Password");
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

    // TODO: call verify OTP API with `code`
    print("Verifying OTP: $code");

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