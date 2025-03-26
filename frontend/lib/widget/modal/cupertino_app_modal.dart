import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';

abstract class CupertinoAppModal<T> extends AppModal<T> {
  CupertinoAppModal(
    super.context, {
    required super.vsync,
    super.onDismiss,
    super.isDismissible,
  });

  @override
  void initializeAnimations() {
    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    translateAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero, // Move to center
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context, AppModal<T> modal) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Transform.translate(
            offset:
                translateAnimation.value * MediaQuery.of(context).size.height,
            child: buildModalContent(context, modal),
          ),
        ),
      ),
    );
  }

  Widget buildModalContent(BuildContext context, AppModal<T> modal);
}
