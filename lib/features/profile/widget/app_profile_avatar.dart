import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

/// Current user's profile picture with a safe dummy fallback.
class AppProfileAvatar extends StatelessWidget {
  final double size;

  const AppProfileAvatar({super.key, this.size = 38});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final pickedImage = controller.pickedAvatarFile.value;
      final imageUrl = controller.networkAvatarUrl.value.trim();
      final dimension = size.w;

      return ClipOval(
        child: pickedImage != null
            ? Image.file(
                pickedImage,
                width: dimension,
                height: dimension,
                fit: BoxFit.cover,
              )
            : imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: dimension,
                    height: dimension,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _DummyAvatar(size: dimension),
                  )
                : _DummyAvatar(size: dimension),
      );
    });
  }
}

class _DummyAvatar extends StatelessWidget {
  final double size;

  const _DummyAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF7B1FE0),
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: size * 0.58,
        color: Colors.white,
      ),
    );
  }
}
