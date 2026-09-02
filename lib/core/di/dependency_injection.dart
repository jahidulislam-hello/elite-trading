import 'package:get/get.dart';
import '../../features/Post/presentation/controller/post_controller.dart';
import '../../features/authentication/auth_service.dart';
import '../../features/authentication/presentation/controller/auth_controller.dart';
import '../../features/bottom_nab_bar/presentation/controller/bottom_nav_controller.dart';
import '../../features/history/presentation/container/history_container.dart';
import '../../features/notification/presentation/controller/notification_controller.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../features/signals/presentation/controller/signal_controller.dart';
import '../../features/subcriptions/presentation/controller/subscriptions_controller.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';

class DependencyInjection {
  DependencyInjection._();

  static Future<void> init() async {
    Get.lazyPut<CacheService>(() => CacheService(), fenix: true);
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);

    // StorageService must be ready before AuthController
    final storageService = StorageService();
    await storageService.init();
    Get.put<StorageService>(storageService, permanent: true);

    // ApiService singleton (uses StorageService for token injection)
    Get.put<ApiService>(ApiService(), permanent: true);

    // AuthService
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    // AuthController — permanent so it survives route changes
    Get.put<AuthController>(AuthController(), permanent: true);

    //---------------------Subscription----------------------------
    Get.lazyPut<SubscriptionsController>(() => SubscriptionsController(), fenix: true);

    //---------------------Signal----------------------------
    Get.lazyPut<SignalController>(() => SignalController(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
    Get.lazyPut<PostController>(() => PostController(), fenix: true);
    Get.lazyPut<HistoryContainer>(() => HistoryContainer(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
  }

  static void clear() {
    Get.deleteAll(force: true);
  }

  /// Drops the permanent tab-shell controllers (see [BottomNavBinding]) so the
  /// next signed-in user starts from empty state instead of cached data.
  static void clearSessionControllers() {
    Get.delete<BottomNavController>(force: true);
    Get.delete<SignalController>(force: true);
    Get.delete<NotificationController>(force: true);
    Get.delete<PostController>(force: true);
    Get.delete<HistoryContainer>(force: true);
    Get.delete<ProfileController>(force: true);
  }
}
