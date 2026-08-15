import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  final VoidCallback? onSuccess;
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
  bool _hasHandled = false; // prevent double-fire

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
              _handleSuccess();
              return NavigationDecision.prevent;
            }

            if (!_hasHandled && _isCancelUrl(url)) {
              _hasHandled = true;
              _handleCancel();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _handleSuccess() {
    // Small delay so WebView teardown is clean
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        } else {
          Get.back();
        }
      }
    });
  }

  void _handleCancel() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        if (widget.onCancel != null) {
          widget.onCancel!();
        } else {
          Get.back();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1830),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            if (!_hasHandled) {
              _hasHandled = true;
              _handleCancel();
            }
          },
        ),
        title: Text(
          'Secure Checkout',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // SSL lock badge
          Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Row(
              children: [
                Icon(Icons.lock_outline, size: 13.sp, color: Colors.greenAccent),
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
      body: Stack(
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
    );
  }
}
