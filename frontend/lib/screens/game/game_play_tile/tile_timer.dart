import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/extensions/text_style_extension.dart';
import 'package:gogogame_frontend/core/services/game/timer_service.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/widget/icons/rotated_icon.dart';

class TileTimer extends ConsumerWidget {
  final DiskColor? color;
  final bool? isPlayerTurn;

  const TileTimer({super.key, required this.color, required this.isPlayerTurn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Builder(
              builder: (context) {
                if (color == null || isPlayerTurn == null) {
                  return const SizedBox();
                }

                final timeLeft = ref.watch(timerService)[color!];

                return SizedBox(
                  width: 85,
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
          );
        },
      ),
    );
  }
}
