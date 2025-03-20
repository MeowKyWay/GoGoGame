import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class RotatedIcon extends StatefulWidget {
  final bool isRunning;
  final Icon icon;

  const RotatedIcon({super.key, this.isRunning = false, required this.icon});

  @override
  State<RotatedIcon> createState() => _RotatedIconState();
}

class _RotatedIconState extends State<RotatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rotationAnimation = CurvedAnimation(
      parent: Tween<double>(begin: 0, end: 1).animate(_controller),
      curve: Curves.easeInOut,
    );

    if (widget.isRunning) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RotatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _controller.forward(from: 0);
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 3.14, // 180 degrees
          child: child,
        );
      },
      child: widget.icon,
    );
  }
}
