/// Central file for all backend API endpoint paths.
///
/// Base URL is defined in [ApiConstants.baseUrl].
/// All paths here are relative to that base URL.
abstract class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth / User ──────────────────────────────────────────────────────────

  /// POST  { firstName, lastName, email, password, confirmPassword }
  static const String register = '/api/v1/user/register';

  /// POST  body: { otp }   Authorization: Bearer <register-token>
  static const String verifyOtp = '/api/v1/user/verify-otp';

  /// POST  { email, password }
  static const String login = '/api/v1/user/login';

  /// POST  Authorization: Bearer <register-token | forgot-token>
  static const String resendOtp = '/api/v1/user/resend-otp';

  /// POST  { email }  → returns { token }
  static const String forgotPassword = '/api/v1/user/forgot-password';

  /// POST  body: { otp }   Authorization: Bearer <forgot-token>
  static const String verifyForgotOtp = '/api/v1/user/verify-forgot-otp';

  /// POST  body: { password, confirmPassword }
  ///        Authorization: Bearer <verifyForgot-token>
  static const String resetPassword = '/api/v1/user/reset-password';

  /// POST  { oldPassword, newPassword, confirmPassword }
  ///        Authorization: Bearer <auth-token>
  static const String changePassword = '/api/v1/user/change-password';

  // ─── Profile ─────────────────────────────────────────────────────────────

  /// GET   Authorization: Bearer <auth-token>
  static const String myProfile = '/api/v1/user/my-profile';

  /// POST  { firstName?, lastName?, email?, phone?, address? }
  static const String updateProfile = '/api/v1/user/update-profile';

  // ─── Subscription Plans ──────────────────────────────────────────────────

  /// GET  → returns list of active subscription plans
  static const String getSubscriptions = '/api/v1/subscription';

  /// GET  /api/v1/subscription/:id
  static String getSubscriptionById(String id) => '/api/v1/subscription/$id';

  /// GET  → trial + promo config
  static const String trialConfig = '/api/v1/subscription/trial-config';

  // ─── User Subscription (protected) ───────────────────────────────────────

  /// GET   Authorization: Bearer  → all user purchases
  static const String userPurchases = '/api/v1/subscription/user/purchases';

  /// GET   Authorization: Bearer  → active subscription
  static const String userCurrentSubscription = '/api/v1/subscription/user/current';

  /// GET   Authorization: Bearer  → trial eligibility status
  static const String userTrialStatus = '/api/v1/subscription/user/trial-status';

  /// POST  { subscriptionId, isFreeTrial, couponCode?, billingCycle? }
  ///        Authorization: Bearer
  /// → returns { checkoutUrl?, paymentRequired, purchase, ... }
  static const String initiatePurchase = '/api/v1/subscription/purchase/initiate';

  // ─── Signal (App / Mobile) ───────────────────────────────────────────────

  /// GET  Authorization: Bearer  → list of active signals (paginated)
  /// Query: page, limit, category, search
  static const String signalsApp = '/api/v1/signal/app';

  /// GET  Authorization: Bearer  → global market hours
  static const String signalMarketHours = '/api/v1/signal/app/market-hours';

  /// GET  Authorization: Bearer  → closed-signal history (paginated)
  static const String signalsHistory = '/api/v1/signal/app/history';

  /// GET  /api/v1/signal/app/:id  → signal detail
  static String signalDetail(String id) => '/api/v1/signal/app/$id';

  /// GET  /api/v1/signal/app/:id/chart  → chart candles
  /// Query: timeframe (1H | 24H | 3D | 1W | 1M | 6M)
  static String signalChart(String id) => '/api/v1/signal/app/$id/chart';

  /// GET  /api/v1/signal/app/:id/market  → market stats
  static String signalMarket(String id) => '/api/v1/signal/app/$id/market';

  /// POST /api/v1/signal/app/:id/favorite  body: { enabled: bool }
  static String signalFavorite(String id) => '/api/v1/signal/app/$id/favorite';

  /// POST /api/v1/signal/app/:id/alerts   body: { enabled: bool }
  static String signalAlerts(String id) => '/api/v1/signal/app/$id/alerts';

  // ─── Post (App / Mobile) ─────────────────────────────────────────────────

  /// GET  Authorization: Bearer  → list of published posts (paginated)
  /// Query: page, limit, category
  static const String postsApp = '/api/v1/post/app';

  /// GET  /api/v1/post/app/:id  → post detail
  static String postDetail(String id) => '/api/v1/post/app/$id';

  /// GET  /api/v1/post/app/:id/comments  → post comments (paginated)
  static String postComments(String id) => '/api/v1/post/app/$id/comments';

  /// POST /api/v1/post/app/:id/comments  body: { text }
  static String createComment(String id) => '/api/v1/post/app/$id/comments';

  /// PATCH /api/v1/post/app/comments/:commentId  body: { text }
  static String updateComment(String commentId) =>
      '/api/v1/post/app/comments/$commentId';

  /// DELETE /api/v1/post/app/comments/:commentId
  static String deleteComment(String commentId) =>
      '/api/v1/post/app/comments/$commentId';

  /// POST /api/v1/post/app/:id/like
  static String togglePostLike(String id) => '/api/v1/post/app/$id/like';

  /// POST /api/v1/post/app/:id/share
  static String sharePost(String id) => '/api/v1/post/app/$id/share';

  /// POST /api/v1/post/app/comments/:commentId/like
  static String toggleCommentLike(String commentId) =>
      '/api/v1/post/app/comments/$commentId/like';

  // ─── Notification (App / Mobile) ─────────────────────────────────────────

  /// GET  Authorization: Bearer  → list of notifications (paginated)
  /// Query: page, limit
  static const String notificationsApp = '/api/v1/notification/app';

  /// GET  Authorization: Bearer  → { unreadCount }
  static const String notificationUnreadCount =
      '/api/v1/notification/app/unread-count';

  /// POST /api/v1/notification/app/:notificationId/read
  static String markNotificationRead(String id) =>
      '/api/v1/notification/app/$id/read';

  /// POST /api/v1/notification/app/read-all
  static const String markAllNotificationsRead =
      '/api/v1/notification/app/read-all';

  // ─── Dashboard ───────────────────────────────────────────────────────────
  static const String dashboard = '/api/v1/dashboard';

  // ─── File Upload ─────────────────────────────────────────────────────────
  static const String upload = '/api/v1/upload';
}
