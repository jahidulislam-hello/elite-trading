import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAvatarWidget extends StatefulWidget {
  final String networkImageUrl;
  final ValueChanged<File>? onImagePicked;

  const ProfileAvatarWidget({
    super.key,
    required this.networkImageUrl,
    this.onImagePicked,
  });

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  File? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
        widget.onImagePicked?.call(_pickedImage!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ছবি নেওয়া যায়নি: $e')),
        );
      }
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1530),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Text(
                'Update Profile Photo',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _sourceOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _sourceOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  Widget _sourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9B2BFF), Color(0xFF6A1BFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8A2BE2).withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreenImage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.95),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _FullScreenImageViewer(
              pickedImage: _pickedImage,
              networkImageUrl: widget.networkImageUrl,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // -------- Avatar (tap => full screen preview) --------
        GestureDetector(
          onTap: _openFullScreenImage,
          child: Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3A2E63), Color(0xFF241B3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: ClipOval(
              child: _pickedImage != null
                  ? Image.file(
                      _pickedImage!,
                      width: 90.w,
                      height: 90.w,
                      fit: BoxFit.cover,
                    )
                  : (widget.networkImageUrl.isNotEmpty
                      ? Image.network(
                          widget.networkImageUrl,
                          width: 90.w,
                          height: 90.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90.w,
                            height: 90.w,
                            color: const Color(0xFF7B1FE0),
                            alignment: Alignment.center,
                            child: Icon(Icons.person,
                                color: Colors.white70, size: 36.sp),
                          ),
                        )
                      : Container(
                          width: 90.w,
                          height: 90.w,
                          color: const Color(0xFF7B1FE0),
                          alignment: Alignment.center,
                          child: Icon(Icons.person,
                              color: Colors.white70, size: 36.sp),
                        )),
            ),
          ),
        ),

        // -------- "+" button (tap => bottom sheet: camera/gallery) --------
        Positioned(
          bottom: -2.h,
          right: -2.w,
          child: GestureDetector(
            onTap: _showImageSourceSheet,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B2BFF), Color(0xFF6A1BFF)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0F0B1E), width: 2),
              ),
              child: Icon(Icons.add, size: 14.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _FullScreenImageViewer extends StatelessWidget {
  final File? pickedImage;
  final String networkImageUrl;

  const _FullScreenImageViewer({
    required this.pickedImage,
    required this.networkImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: pickedImage != null
                    ? Image.file(pickedImage!, fit: BoxFit.contain)
                    : Image.network(networkImageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            right: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 22.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}