import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';
import 'package:gogogame_frontend/core/services/game/game_sound_effect_service.dart';
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
    with TickerProviderStateMixin {
  late final AnimationController _flipController;
  late final AnimationController _initialScaleController;
  late final Animation<double> _flipAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _initialScaleAnimation;
  late DiskColor _previousColor;

  late final GameSoundEffectService soundEffectService;

  bool _hasPlayedSound = false;

  @override
  void initState() {
    super.initState();

    soundEffectService = ref.read(gameSoundEffectService);

    _previousColor = widget.color;

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initialScaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeOutBack),
    );
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.linearToEaseOut),
    );

    _initialScaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _initialScaleController,
        curve: Curves.easeOutBack,
      ),
    );

    _flipAnimation.addListener(() {
      if (_flipAnimation.value >= pi / 2 && _previousColor != widget.color) {
        setState(() {
          _previousColor = widget.color;
        });
        _hasPlayedSound = false;
      }
      if (_flipAnimation.value >= 3 * pi / 4 && !_hasPlayedSound) {
        _hasPlayedSound = true;
        soundEffectService.playDiskSound();
      }
    });

    _initialScaleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        soundEffectService.playDiskSound();
      }
    });

    // Start initial scale animation when the widget is first rendered
    _initialScaleController.forward();
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
        _flipController.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configService);
    final theme = config.gameTheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_flipController, _initialScaleController]),
      builder: (context, child) {
        final double angle = _flipAnimation.value;
        final double scale =
            (_initialScaleController.isAnimating)
                ? _initialScaleAnimation.value
                : _scaleAnimation.value;
        final bool showNewColor = angle > pi / 2;

        return Transform(
          transform:
              Matrix4.identity()
                ..scale(scale)
                ..rotateY(angle)
                ..scale(showNewColor ? -1.0 : 1.0, 1.0),
          alignment: Alignment.center,
          child: Disk(color: _previousColor, theme: theme),
        );
      },
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _initialScaleController.dispose();
    super.dispose();
  }
}
