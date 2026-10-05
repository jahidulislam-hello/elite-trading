import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';


/// Opens a Stripe Checkout URL inside the app.
///
/// The backend's success_url is:
///   http(s)://FRONTEND_URL/subscription/success?session_id=...
/// The backend's cancel_url is:
///   http(s)://FRONTEND_URL/subscription/cancelled
///
/// We intercept these URLs inside the WebView and navigate accordingly.
///
/// Usage:
/// ```dart
/// Get.to(() => StripeWebViewScreen(
///   checkoutUrl: result.checkoutUrl!,
///   onSuccess: () { /* navigate home */ },
///   onCancel:  () { /* pop back to plan screen */ },
/// ));
/// ```
class StripeWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final void Function(String? sessionId)? onSuccess;
  final VoidCallback? onCancel;

  const StripeWebViewScreen({
    super.key,
    required this.checkoutUrl,
    this.onSuccess,
    this.onCancel,
  });

  @override
  State<StripeWebViewScreen> createState() => _StripeWebViewScreenState();
}

class _StripeWebViewScreenState extends State<StripeWebViewScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _hasHandled = false; // prevent double-fire of the result callbacks
  bool _isClosing = false;

  /// URL fragments the backend injects for success / cancel.
  /// Match both localhost and any production domain.
  static bool _isSuccessUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.path.contains('/subscription/success');
  }

  static bool _isCancelUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.path.contains('/subscription/cancelled');
  }

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0F0B1E))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (!_hasHandled && _isSuccessUrl(url)) {
              _hasHandled = true;
              final uri = Uri.tryParse(url);
              final sessionId = uri?.queryParameters['session_id'];
              _handleResult(
                success: true,
                sessionId: sessionId,
                delayed: true,
              );
              return NavigationDecision.prevent;
            }

            if (!_hasHandled && _isCancelUrl(url)) {
              _hasHandled = true;
              _handleResult(success: false, delayed: true);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  /// Closes this route through its own [Navigator], then reports the outcome.
  ///
  /// Get.back() is unsafe here: a GetX snackbar is also a route, so it would
  /// pop the snackbar and leave the checkout on screen.
  void _handleResult({
    required bool success,
    String? sessionId,
    bool delayed = false,
  }) {
    if (_isClosing) return;
    _isClosing = true;
    _hasHandled = true;

    void close() {
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) navigator.pop();

      if (success) {
        widget.onSuccess?.call(sessionId);
      } else {
        widget.onCancel?.call();
      }
    }

    if (delayed) {
      // Give the WebView a moment to settle before tearing the route down.
      Future.delayed(const Duration(milliseconds: 300), close);
    } else {
      close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Route the hardware/gesture back through the same cancel path so the
      // caller always learns the checkout was abandoned.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleResult(success: false);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0B1E),
        body: SafeArea(
          child: Column(
            children: [
              _CheckoutHeader(onClose: () => _handleResult(success: false)),
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _webViewController),
                    if (_isLoading)
                      Container(
                        color: const Color(0xFF0F0B1E),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: Color(0xFF7B1FE0),
                                strokeWidth: 2.5,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Loading secure checkout…',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _CancelFooter(onCancel: () => _handleResult(success: false)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Plain Flutter header laid out above the WebView instead of an [AppBar], so
/// the native web view can never overlap the close button's hit area.
class _CheckoutHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _CheckoutHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      color: const Color(0xFF1B1830),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44.w,
              height: 44.w,
              alignment: Alignment.center,
              child: Icon(Icons.close, color: Colors.white, size: 22.sp),
            ),
          ),
          Expanded(
            child: Text(
              'Secure Checkout',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Row(
              children: [
                Icon(Icons.lock_outline,
                    size: 13.sp, color: Colors.greenAccent),
                SizedBox(width: 4.w),
                Text(
                  'Stripe',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelFooter extends StatelessWidget {
  final VoidCallback onCancel;
  const _CancelFooter({required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1B1830),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: GestureDetector(
        onTap: onCancel,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            'Cancel and go back',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
