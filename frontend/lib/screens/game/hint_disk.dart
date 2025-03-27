import 'package:flutter/widgets.dart';
import 'package:gogogame_frontend/core/constants/game_constant.dart';
import 'package:gogogame_frontend/core/themes/game_theme/game_theme.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/widget/general/disk.dart';

class HintDisk extends StatefulWidget {
  final DiskColor color;
  final bool shouldShow;
  final GameTheme theme;

  const HintDisk({
    super.key,
    required this.color,
    this.shouldShow = true,
    required this.theme,
  });

  @override
  State<HintDisk> createState() => _HintDiskState();
}

class _HintDiskState extends State<HintDisk>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Better popping effect
    );

    if (widget.shouldShow) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant HintDisk oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.shouldShow != widget.shouldShow) {
      if (widget.shouldShow && !_controller.isAnimating) {
        _controller.forward();
      } else if (!widget.shouldShow && !_controller.isAnimating) {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose first
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: GameConstant.cellSize * 0.4,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Disk(color: widget.color, theme: widget.theme),
        ),
      ),
    );
  }
}
