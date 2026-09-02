import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../management_service.dart';

/// Loads and renders HTML policy content from the management API.
class PolicyContent extends StatefulWidget {
  final ManagementType type;

  const PolicyContent({super.key, required this.type});

  @override
  State<PolicyContent> createState() => _PolicyContentState();
}

class _PolicyContentState extends State<PolicyContent> {
  final ManagementService _service = ManagementService();

  bool _isLoading = true;
  String? _error;
  String _html = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant PolicyContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final html = await _service.getDescription(widget.type);
      if (!mounted) return;
      setState(() {
        _html = html;
        _isLoading = false;
      });
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load content. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.01),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7B1FE0),
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 28.sp),
            SizedBox(height: 10.h),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.white54,
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: _load,
              child: Text(
                'Retry',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFF7B1FE0),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Html(
      data: _html,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: Colors.white,
          fontSize: FontSize(12.sp),
          fontFamily: GoogleFonts.poppins().fontFamily,
          lineHeight: LineHeight(1.6),
        ),
        'h1': Style(
          color: Colors.white,
          fontSize: FontSize(18.sp),
          fontWeight: FontWeight.w700,
          margin: Margins.only(bottom: 10.h),
        ),
        'h2': Style(
          color: Colors.white,
          fontSize: FontSize(15.sp),
          fontWeight: FontWeight.w700,
          margin: Margins.only(top: 14.h, bottom: 8.h),
        ),
        'h3': Style(
          color: Colors.white,
          fontSize: FontSize(14.sp),
          fontWeight: FontWeight.w600,
          margin: Margins.only(top: 12.h, bottom: 6.h),
        ),
        'p': Style(
          color: Colors.white,
          fontSize: FontSize(12.sp),
          margin: Margins.only(bottom: 10.h),
          lineHeight: LineHeight(1.6),
        ),
        'li': Style(
          color: Colors.white,
          fontSize: FontSize(12.sp),
          margin: Margins.only(bottom: 4.h),
        ),
        'ul': Style(margin: Margins.only(bottom: 10.h, left: 8.w)),
        'ol': Style(margin: Margins.only(bottom: 10.h, left: 8.w)),
        'a': Style(
          color: const Color(0xFF9B6BFF),
          textDecoration: TextDecoration.underline,
        ),
        'strong': Style(color: Colors.white, fontWeight: FontWeight.w700),
        'b': Style(color: Colors.white, fontWeight: FontWeight.w700),
        'i': Style(color: Colors.white70, fontStyle: FontStyle.italic),
        'em': Style(color: Colors.white70, fontStyle: FontStyle.italic),
      },
    );
  }
}
