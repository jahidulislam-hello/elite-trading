import 'dart:io';
import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screen/Help_support_screen.dart';
import '../screen/about_screen.dart';
import '../screen/personal_info.dart';
import '../screen/terms_condition_screen.dart';
import '../widget/change_password_sheet.dart';
import '../widget/sign_out_dialog.dart';

class ProfileController extends GetxController {
  //---------------- User info ----------------
  final String userAvatar = 'asset/image/profile/alex.png';
  final String userName = 'AL Jamil';
  final String userEmail = 'alex.kim@elitetrading.com';
  final RxBool isPremiumMember = true.obs;

  //---------------- Avatar (Personal Info screen) ----------------
  final String networkAvatarUrl =
      'https://media.sproutsocial.com/uploads/2022/06/profile-picture.jpeg';
  final Rx<File?> pickedAvatarFile = Rx<File?>(null);

  void onAvatarSelected(File file) {
    pickedAvatarFile.value = file;
  }

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
      enableDrag: true,
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

  //---------------- Personal Info ----------------
  final personalInfoFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController(text: 'Lois');
  final TextEditingController lastNameController = TextEditingController(text: 'Becket');
  final TextEditingController emailAddressController = TextEditingController();
  final RxBool isSavingPersonalInfo = false.obs;

  void onSavePersonalInfoPressed() async {
    if (personalInfoFormKey.currentState!.validate()) {
      isSavingPersonalInfo.value = true;
      // TODO: call update-profile API (pickedAvatarFile.value থাকলে সেটাও পাঠাও)
      await Future.delayed(const Duration(milliseconds: 600));
      isSavingPersonalInfo.value = false;
      Get.back();
      Get.snackbar('Success', 'Personal info updated successfully');
    }
  }

  //---------------- Help & Support ----------------
  final String supportEmail = 'example12345@gmail.com';

  void onContactSupportPressed() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: _encodeQueryParameters({
        'subject': 'Support Request - Elite Trading',
      }),
    );

    try {
      final launched = await launchUrl(emailUri);
      if (!launched) {
        Get.snackbar('Error', 'Could not open email app');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open email app');
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  //---------------- Menu actions ----------------
  void onPersonalInfoPressed() => Get.to(() => const PersonalInfo());
  void onNotificationSettingsPressed() => print("Notification Settings tapped");
  void onHelpSupportPressed() => Get.to(() => const HelpSupportScreen());
  void onTermsConditionsPressed() => Get.to(() => const TermsConditionScreen());
  void onAboutPressed() => Get.to(() => const AboutScreen());

  //---------------- Sign out ----------------
  void onSignOutPressed() {
    Get.dialog(
      SignOutDialog(
        onConfirm: () {
          Get.offAllNamed(AppRoutes.signInScreen);
        },
      ),
      barrierDismissible: true,
    );
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
    super.onClose();
  }
}