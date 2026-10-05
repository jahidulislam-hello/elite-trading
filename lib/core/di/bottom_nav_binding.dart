import 'package:get/get.dart';
import '../../features/Post/presentation/controller/post_controller.dart';
import '../../features/bottom_nab_bar/presentation/controller/bottom_nav_controller.dart';
import '../../features/history/presentation/container/history_container.dart';
import '../../features/notification/presentation/controller/notification_controller.dart';
import '../../features/profile/controller/profile_controller.dart';
import '../../features/signals/presentation/controller/signal_controller.dart';

/// Registers the controllers behind the persistent tab shell.
///
/// They are [permanent] on purpose: `Get.offAllNamed` disposes non-permanent
/// controllers when it tears down the old routes, which happens *after* the new
/// shell has already subscribed to them. The widgets would then be listening to
/// a dead instance while taps went to a freshly recreated one, leaving the nav
/// bar visually stuck.
class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    _ensure<BottomNavController>(() => BottomNavController());
    _ensure<SignalController>(() => SignalController());
    _ensure<NotificationController>(() => NotificationController());
    _ensure<PostController>(() => PostController());
    _ensure<HistoryContainer>(() => HistoryContainer());
    _ensure<ProfileController>(() => ProfileController());
  }

  /// Keeps a live instance if one already exists, so re-entering the shell
  /// never swaps the instance the mounted widgets are bound to.
  void _ensure<T>(T Function() create) {
    if (Get.isRegistered<T>()) return;
    Get.put<T>(create(), permanent: true);
  }
}
