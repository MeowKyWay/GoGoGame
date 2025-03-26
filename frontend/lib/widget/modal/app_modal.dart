import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gogogame_frontend/widget/modal/modal_background.dart';

abstract class AppModal<T> {
  OverlayEntry? _entry;
  final BuildContext context;
  final TickerProvider vsync;
  final Function()? onDismiss;
  late final AnimationController controller;
  late final Animation<double> opacityAnimation;
  late final Animation<Offset> translateAnimation;
  final Completer<T?> completer = Completer<T?>(); // For returning a value

  final bool isDismissible;

  AppModal(
    this.context, {
    required this.vsync,
    this.onDismiss,
    this.isDismissible = true,
  }) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );

    initializeAnimations(); // ✅ Initialize animations separately
  }

  /// Initializes animation properties
  void initializeAnimations() {
    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    translateAnimation = Tween<Offset>(
      begin: const Offset(0, 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  Widget build(BuildContext context, AppModal<T> modal);

  Future<T?> show() {
    _entry = OverlayEntry(
      builder:
          (context) => AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Opacity(
                opacity: opacityAnimation.value,
                child: ModalBackground(
                  imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                  onTap: isDismissible ? () => hide() : null,
                  child: Transform.translate(
                    offset: translateAnimation.value,
                    child: GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.translucent,
                      child: build(context, this),
                    ),
                  ),
                ),
              );
            },
          ),
    );

    Overlay.of(context).insert(_entry!);
    controller.forward();

    return completer.future;
  }

  void hide([T? result]) {
    controller.reverse().then((_) {
      _entry?.remove();
      _entry = null;
      onDismiss?.call();
      completer.complete(result); // Return the result when modal closes
    });
  }
}
