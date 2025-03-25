import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/widget/general/disk.dart';

class ReverseAnimatedDisk extends StatefulWidget {
  final DiskColor color;

  const ReverseAnimatedDisk({Key? key, required this.color}) : super(key: key);

  @override
  State<ReverseAnimatedDisk> createState() => _ReverseAnimatedDiskState();
}

class _ReverseAnimatedDiskState extends State<ReverseAnimatedDisk>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    log('ReverseAnimatedDisk: ${widget.color}');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Disk(color: widget.color),
        );
      },
    );
  }
}
