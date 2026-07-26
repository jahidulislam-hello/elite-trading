import 'package:get/get.dart';
import '../../features/authentication/presentation/controller/auth_controller.dart';
import '../../features/subcriptions/presentation/controller/subscriptions_controller.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';


class DependencyInjection {

  DependencyInjection._();

  static Future<void> init() async {
    Get.lazyPut<CacheService>(() => CacheService(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);
    final storageService = StorageService();
    await storageService.init();
    Get.put<StorageService>(storageService, permanent: true);

    //---------------------Onboarding----------------------------
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

    //---------------------Subscription----------------------------
    Get.lazyPut<SubscriptionsController>(() => SubscriptionsController(), fenix: true);


  }

  static void clear() {
    Get.deleteAll(force: true);
  }
}