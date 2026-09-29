import 'dart:io';
import 'package:elite_trading/core/exceptions/app_exceptions.dart';
import 'package:elite_trading/core/utils/media_url.dart';
import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:elite_trading/core/services/storage_service.dart';
import 'package:elite_trading/features/authentication/auth_service.dart';
import 'package:elite_trading/features/authentication/data/user_model.dart';
import 'package:elite_trading/features/authentication/presentation/controller/auth_controller.dart';
import 'package:elite_trading/features/profile/screen/privacy_policy_screen.dart';
import 'package:elite_trading/features/signals/presentation/controller/signal_controller.dart';
import 'package:elite_trading/features/subcriptions/presentation/controller/subscriptions_controller.dart';
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
  final AuthService _authService = AuthService();
  late final StorageService _storage;

  // ─── Profile state ─────────────────────────────────────────────────────────
  final Rx<UserModel?> profile = Rx<UserModel?>(null);
  final RxBool isProfileLoading = false.obs;
  final RxString profileError = ''.obs;

  final RxString userName = 'Trader'.obs;
  final RxString userEmail = ''.obs;
  final RxString networkAvatarUrl = ''.obs;
  final RxBool isPremiumMember = false.obs;
  final RxString memberBadgeLabel = 'PREMIUM MEMBER'.obs;
  final RxString planLabel = 'FREE PLAN'.obs;
  final RxString planStatus = 'No active subscription'.obs;

  final Rx<File?> pickedAvatarFile = Rx<File?>(null);

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  void onAvatarSelected(File file) {
    pickedAvatarFile.value = file;
  }

  // ─── Change password ───────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool isSavingPassword = false.obs;

  // ─── Personal info ─────────────────────────────────────────────────────────
  final personalInfoFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final RxBool isSavingPersonalInfo = false.obs;

  // ─── Help & Support ────────────────────────────────────────────────────────
  final String supportEmail = 'example12345@gmail.com';
  final String telegramUsername = 'elitetradingsupport';

  @override
  void onInit() {
    super.onInit();
    _storage = Get.find<StorageService>();
    userName.value = _storage.getString(StorageKeys.userName) ?? 'Trader';
    userEmail.value = _storage.getString(StorageKeys.userEmail) ?? '';
    loadProfile();
  }

  Future<void> loadProfile({bool silent = false}) async {
    if (!silent) {
      isProfileLoading.value = true;
      profileError.value = '';
    }
    try {
      final user = await _authService.myProfile();
      _applyUser(user);
    } on AppException catch (e) {
      profileError.value = e.message;
      if (!silent) _showError(e.message);
    } catch (e, s) {
      debugPrint('loadProfile failed: $e\n$s');
      profileError.value = 'Failed to load profile.';
      if (!silent) _showError(profileError.value);
    } finally {
      isProfileLoading.value = false;
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${_monthNames[local.month - 1]} ${local.day}, ${local.year}';
  }

  void _applyUser(UserModel user) {
    profile.value = user;
    userName.value = user.displayName;
    userEmail.value = user.email;

    final avatar = user.image?.publicFileURL;
    networkAvatarUrl.value = resolveMediaUrl(avatar);

    final status = user.subscriptionStatus.toLowerCase();
    final hasAccess = status == 'active' || status == 'trial';
    isPremiumMember.value = hasAccess;

    final planType = (user.subscriptionType ?? '').trim();
    if (hasAccess && planType.isNotEmpty) {
      memberBadgeLabel.value = '${planType.toUpperCase()} MEMBER';
      planLabel.value = '${planType.toUpperCase()} PLAN';
    } else if (hasAccess) {
      memberBadgeLabel.value = 'PREMIUM MEMBER';
      planLabel.value = 'PREMIUM PLAN';
    } else {
      memberBadgeLabel.value = '';
      planLabel.value = 'FREE PLAN';
    }

    if (hasAccess && user.subscriptionEndDate != null) {
      final prefix = status == 'trial' ? 'Trial until' : 'Active until';
      planStatus.value = '$prefix ${_formatDate(user.subscriptionEndDate!)}';
    } else if (hasAccess) {
      planStatus.value = status == 'trial' ? 'Trial active' : 'Active';
    } else {
      planStatus.value = 'No active subscription';
    }

    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    emailAddressController.text = user.email;

    _storage.setString(StorageKeys.userName, user.displayName);
    _storage.setString(StorageKeys.userEmail, user.email);
    _storage.setString(StorageKeys.userId, user.id);

    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().currentUser.value = user;
    }
    if (Get.isRegistered<SignalController>()) {
      Get.find<SignalController>().userName.value = user.displayName;
    }
  }

  void onChangePasswordPressed() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
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

  Future<void> onSaveChangePressed() async {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      _showError('New password and confirm password do not match');
      return;
    }

    isSavingPassword.value = true;
    try {
      await _authService.changePassword(
        oldPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      Get.back();
      _showSuccess('Password changed successfully');
    } on AppException catch (e) {
      _showError(e.message);
    } catch (e, s) {
      debugPrint('changePassword failed: $e\n$s');
      _showError('Failed to change password. Please try again.');
    } finally {
      isSavingPassword.value = false;
    }
  }

  Future<void> onSavePersonalInfoPressed() async {
    if (!personalInfoFormKey.currentState!.validate()) return;

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final fullName = '$firstName $lastName'.trim();

    isSavingPersonalInfo.value = true;
    try {
      final updated = await _authService.updateProfile(
        name: fullName.isNotEmpty ? fullName : null,
        firstName: firstName.isNotEmpty ? firstName : null,
        lastName: lastName.isNotEmpty ? lastName : null,
        phone: profile.value?.phone,
        address: profile.value?.address,
      );
      _applyUser(updated);
      Get.back();
      _showSuccess('Personal info updated successfully');
    } on AppException catch (e) {
      _showError(e.message);
    } catch (e, s) {
      debugPrint('updateProfile failed: $e\n$s');
      _showError('Failed to update profile. Please try again.');
    } finally {
      isSavingPersonalInfo.value = false;
    }
  }

  Future<void> onContactSupportPressed() async {
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
        _showError('Could not open email app');
      }
    } catch (_) {
      _showError('Could not open email app');
    }
  }

  Future<void> onContactTelegramPressed() async {
    final Uri telegramUri = Uri.parse('https://t.me/$telegramUsername');

    try {
      final launched = await launchUrl(
        telegramUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _showError('Could not open Telegram');
      }
    } catch (_) {
      _showError('Could not open Telegram');
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void onPersonalInfoPressed() {
    final user = profile.value;
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      emailAddressController.text = user.email;
    }
    Get.to(() => const PersonalInfo());
  }

  /// Opens the full plan list so the user can review or change their plan.
  void onPlanCardPressed() {
    if (Get.isRegistered<SubscriptionsController>()) {
      final subscriptions = Get.find<SubscriptionsController>();
      subscriptions.currentStep.value = 2;
      if (!subscriptions.isPlansLoading.value) subscriptions.loadPlans();
    }
    Get.toNamed(AppRoutes.choosePlanScreen);
  }

  void onNotificationSettingsPressed() =>
      debugPrint('Notification Settings tapped');
  void onHelpSupportPressed() => Get.to(() => const HelpSupportScreen());
  void onTermsConditionsPressed() =>
      Get.to(() => const TermsConditionScreen());
  void onPrivacyPolicyPressed() =>
      Get.to(() => const PrivacyPolicyScreen());
  void onAboutPressed() => Get.to(() => const AboutScreen());

  void onSignOutPressed() {
    Get.dialog(
      SignOutDialog(
        onConfirm: () async {
          await Get.find<AuthController>().signOut();
        },
      ),
      barrierDismissible: true,
    );
  }

  void _showError(String msg) {
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
