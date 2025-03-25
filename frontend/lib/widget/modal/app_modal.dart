import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gogogame_frontend/widget/modal/modal_background.dart';

abstract class AppModal<T> {
  OverlayEntry? _entry;
  final BuildContext _context;
  final Function()? onDismiss;
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _translateAnimation;
  final Completer<T?> _completer = Completer<T?>(); // For returning a value

  final bool isDissmissable;

  AppModal(this._context, {this.onDismiss, this.isDissmissable = true}) {
    _controller = AnimationController(
      vsync: Navigator.of(_context),
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _translateAnimation = Tween<Offset>(
      begin: const Offset(0, 100),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Widget build(BuildContext context, AppModal<T> modal);

  Future<T?> show() {
    _entry = OverlayEntry(
      builder:
          (context) => AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: ModalBackground(
                  imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                  onTap: isDissmissable ? () => hide() : null,
                  child: Transform.translate(
                    offset: _translateAnimation.value,
                    child: build(context, this),
                  ),
                ),
              );
            },
          ),
    );

    Overlay.of(_context).insert(_entry!);
    _controller.forward();

    return _completer.future;
  }

  void hide([T? result]) {
    _controller.reverse().then((_) {
      _entry?.remove();
      _entry = null;
      onDismiss?.call();
      _completer.complete(result); // Return the result when modal closes
    });
  }
}
