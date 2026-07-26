import 'package:get/get.dart';
import '../../features/authentication/presentation/screen/forgot_password_screen.dart';
import '../../features/authentication/presentation/screen/register_screen.dart';
import '../../features/authentication/presentation/screen/reset_pass_screen.dart';
import '../../features/authentication/presentation/screen/sign_in_screen.dart';
import '../../features/authentication/presentation/screen/verification_screen.dart';
import '../../features/onboarding/presentation/screen/onbording_one.dart';
import '../../features/onboarding/presentation/screen/onbording_start_screen.dart';
import '../../features/onboarding/presentation/screen/onebording_three.dart';
import '../../features/onboarding/presentation/screen/onebording_two.dart';
import '../../features/onboarding/presentation/screen/splash_screen.dart';
import '../../features/subcriptions/presentation/screen/add_prement_screen.dart';
import '../../features/subcriptions/presentation/screen/choose_plan_screen.dart';
import '../../features/subcriptions/presentation/screen/conform_trial.dart';
import '../../features/subcriptions/presentation/screen/subscrip_first_page.dart';
import 'app_routes.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> routes = [

    //---------------------Onboarding----------------------------
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onbordingOne,
      page: () => const OnbordingOne(),
    ),
    GetPage(
      name: AppRoutes.onebordingTwo,
      page: () => const OnebordingTwo(),
    ),
    GetPage(
      name: AppRoutes.onebordingThree,
      page: () => const OnebordingThree(),
    ),
    GetPage(
      name: AppRoutes.onbordingStartScreen,
      page: () => const OnbordingStartScreen(),
    ),


    //---------------------Onboarding----------------------------
    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.resetPassScreen,
      page: () => const ResetPassScreen(),
    ),
    GetPage(
      name: AppRoutes.verificationScreen,
      page: () => const VerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.signInScreen,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: AppRoutes.registerScreen,
      page: () => const RegisterScreen(),
    ),


    //------------------------------Subscription-------------------
    GetPage(
      name: AppRoutes.subscripFirstPage,
      page: () => const SubscripFirstPage(),
    ),
    GetPage(
      name: AppRoutes.choosePlanScreen,
      page: () => const ChoosePlanScreen(),
    ),
    GetPage(
      name: AppRoutes.addPrementScreen,
      page: () => const AddPrementScreen(),
    ),
    GetPage(
      name: AppRoutes.conformTrial,
      page: () => const ConformTrial(),
    ),

  ];
}

