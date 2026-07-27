import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/change_password_sheet.dart';

class ProfileController extends GetxController {
  //---------------- User info ----------------
  final String userAvatar = 'asset/image/profile/alex.png';
  final String userName = 'AL Jamil';
  final String userEmail = 'alex.kim@elitetrading.com';
  final RxBool isPremiumMember = true.obs;

  //---------------- Plan info ----------------
  final String planLabel = 'PREMIUM PLAN';
  final String planStatus = 'Active until Dec 31, 2026';

  //---------------- Change password bottom sheet ----------------
  final formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxBool isSavingPassword = false.obs;

  void onChangePasswordPressed() {
    Get.bottomSheet(
      const ChangePasswordSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void onForgotPasswordPressed() {
    Get.back();
    Get.toNamed(AppRoutes.forgotPasswordScreen);
  }

  void onSaveChangePressed() {
    if (formKey.currentState!.validate()) {
      if (newPasswordController.text != confirmPasswordController.text) {
        Get.snackbar('Error', 'New password and confirm password do not match');
        return;
      }
      isSavingPassword.value = true;
      // TODO: call change password API
      print("Changing password...");
      isSavingPassword.value = false;
      Get.back();
      Get.snackbar('Success', 'Password changed successfully');
    }
  }

  //---------------- Avatar edit ----------------
  void onEditAvatarPressed() {
    print("Edit avatar tapped");
    // TODO: image picker
  }

  //---------------- Menu actions ----------------
  void onPersonalInfoPressed() => print("Personal Info tapped");
  void onNotificationSettingsPressed() => print("Notification Settings tapped");
  void onHelpSupportPressed() => print("Help & Support tapped");
  void onTermsConditionsPressed() => print("Terms & Conditions tapped");
  void onAboutPressed() => print("About Elite Trading tapped");

  //---------------- Sign out ----------------
  void onSignOutPressed() {
    Get.defaultDialog(
      backgroundColor: const Color(0xFF1B1830),
      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      title: 'Sign Out',
      middleText: 'Are you sure you want to sign out?',
      middleTextStyle: const TextStyle(color: Colors.white70),
      textConfirm: 'Sign Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFE0405C),
      onConfirm: () {
        Get.offAllNamed(AppRoutes.signInScreen);
      },
    );
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}