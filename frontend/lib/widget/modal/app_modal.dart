import 'package:flutter/material.dart';

abstract class AppModal {
  OverlayEntry? _entry;
  final BuildContext _context;
  final Function()? onDismiss;
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  AppModal(this._context, {this.onDismiss}) {
    _controller = AnimationController(
      vsync: Navigator.of(_context),
      duration: const Duration(milliseconds: 100),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Widget build(BuildContext context, AppModal modal);

  void show() {
    _entry = OverlayEntry(
      builder:
          (context) => FadeTransition(
            opacity: _opacityAnimation,
            child: build(_context, this),
          ),
    );

    Overlay.of(_context).insert(_entry!);
    _controller.forward();
  }

  void hide() {
    _controller.reverse().then((_) {
      _entry?.remove();
      _entry = null;
      onDismiss?.call();
    });
  }
}
