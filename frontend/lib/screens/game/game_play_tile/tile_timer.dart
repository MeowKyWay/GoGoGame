import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/color_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/core/services/game/timer_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/widget/icon/rotated_icon.dart';

class TileTimer extends ConsumerWidget {
  final DiskColor? color;
  final bool? isPlayerTurn;

  const TileTimer({super.key, required this.color, required this.isPlayerTurn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 85),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Theme(
          data: context.theme.copyWith(
            colorScheme: context.colorScheme.copyWith(
              primaryContainer:
                  color == DiskColor.white
                      ? context.colorScheme.primaryContainer
                      : context.colorScheme.primary,
              onPrimaryContainer:
                  color == DiskColor.white ? Colors.black : Colors.white,
            ),
          ),
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  if (color == null || isPlayerTurn == null) {
                    return const SizedBox();
                  }
                  final timeLeft = ref.watch(timerService)[color!];
                  return Container(
                    height: 45,
                    width: 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RotatedIcon(
                          isRunning: isPlayerTurn!,
                          icon: Icon(
                            Icons.hourglass_empty_rounded,
                            size: 24,
                            color: ColorScheme.of(context).onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '${(timeLeft! ~/ 60000)}:${((timeLeft % 60000) ~/ 1000).toString().padLeft(2, '0')}',
                          style: context.textTheme.labelMedium?.withColor(
                            context.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: isPlayerTurn! ? 0 : 0.75,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpa(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
