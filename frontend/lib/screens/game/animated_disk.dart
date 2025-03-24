import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/widget/general/disk.dart';

class AnimatedDisk extends ConsumerStatefulWidget {
  final DiskColor color;
  final double delay;

  const AnimatedDisk({super.key, required this.color, this.delay = 0});

  @override
  ConsumerState<AnimatedDisk> createState() => _AnimatedDiskState();
}

class _AnimatedDiskState extends ConsumerState<AnimatedDisk>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;
  late final Animation<double> _scaleAnimation;
  late DiskColor _previousColor;

  @override
  void initState() {
    super.initState();
    _previousColor = widget.color;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(_controller);
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(_controller);

    // Update `_previousColor` at halfway point of the animation
    _flipAnimation.addListener(() {
      if (_flipAnimation.value >= pi / 2 && _previousColor != widget.color) {
        setState(() {
          _previousColor = widget.color;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedDisk oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      animate(widget.delay);
    }
  }

  void animate(double delay) {
    Future.delayed(Duration(milliseconds: (delay * 1000).toInt()), () {
      if (mounted) {
        _controller.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double angle = _flipAnimation.value;
        final double scale = _scaleAnimation.value;
        final bool showNewColor = angle > pi / 2;

        return Transform(
          transform:
              Matrix4.identity()
                ..scale(scale)
                ..rotateY(angle)
                ..scale(
                  showNewColor ? -1.0 : 1.0,
                  1.0,
                ), // Flip image horizontally after rotation
          alignment: Alignment.center,
          child: Disk(color: _previousColor),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
