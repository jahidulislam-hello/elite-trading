import 'package:get/get.dart';
import '../../features/Post/presentation/screen/comment_screen.dart';
import '../../features/Post/presentation/screen/post_screen.dart';
import '../../features/authentication/presentation/screen/forgot_password_screen.dart';
import '../../features/authentication/presentation/screen/register_screen.dart';
import '../../features/authentication/presentation/screen/reset_pass_screen.dart';
import '../../features/authentication/presentation/screen/sign_in_screen.dart';
import '../../features/authentication/presentation/screen/verification_screen.dart';
import '../../features/bottom_nab_bar/presentation/screen/bottom_nav_screen.dart';
import '../../features/history/presentation/screen/history_screen.dart';
import '../../features/notification/presentation/screen/notification_screen.dart';
import '../../features/onboarding/presentation/screen/onbording_one.dart';
import '../../features/onboarding/presentation/screen/onbording_start_screen.dart';
import '../../features/onboarding/presentation/screen/onebording_three.dart';
import '../../features/onboarding/presentation/screen/onebording_two.dart';
import '../../features/onboarding/presentation/screen/splash_screen.dart';
import '../../features/profile/screen/profile_Page.dart';
import '../../features/signals/presentation/screen/all_singnal_screen.dart';
import '../../features/signals/presentation/screen/signal_screen.dart';
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
      page: () =>  SignInScreen(),
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

    //------------------------------Signal-------------------
    GetPage(
      name: AppRoutes.signalScreen,
      page: () => const SignalScreen(),
    ),
    GetPage(
      name: AppRoutes.allSingnalScreen,
      page: () => const AllSingnalScreen(),
    ),

    //------------------------------Notification-------------------
    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => const NotificationScreen(),
    ),

    //------------------------------post-------------------
    GetPage(
      name: AppRoutes.commentScreen,
      page: () => const CommentScreen(),
    ),
    GetPage(
      name: AppRoutes.postScreen,
      page: () => const PostScreen(),
    ),


    //------------------------------History-------------------
    GetPage(
      name: AppRoutes.historyScreen,
      page: () => const HistoryScreen(),
    ),

    //------------------------------Profile-------------------
    GetPage(
      name: AppRoutes.profilePage,
      page: () => const ProfilePage(),
    ),

    //------------------------------Bottom Nav-------------------
    GetPage(
      name: AppRoutes.bottomNavScreen,
      page: () => const BottomNavScreen(),
    ),


  ];
}

