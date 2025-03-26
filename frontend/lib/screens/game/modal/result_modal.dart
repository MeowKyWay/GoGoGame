import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/services/game/game_state.dart';
import 'package:gogogame_frontend/core/types/match_type.dart';
import 'package:gogogame_frontend/widget/general/disk_image.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';
import 'package:gogogame_frontend/widget/modal/center_modal.dart';

class ResultModal extends AppModal {
  final Function() onClose;

  ResultModal(super.context, {required super.vsync, required this.onClose});

  @override
  Widget build(BuildContext context, AppModal modal) {
    return _ResultModal(context: context, modal: this);
  }
}

class _ResultModal extends ConsumerWidget {
  final BuildContext context;
  final ResultModal modal;

  const _ResultModal({required this.context, required this.modal});

  @override
  Widget build(BuildContext _, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final user = ref.watch(authState);
    if (gameState == null || gameState.result == null || user == null) {
      return const SizedBox.shrink();
    }

    MatchResult result = gameState.result!;

    return Theme(
      data: Theme.of(context),
      child: CenterModal(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: FittedBox(
            child: Container(
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(child: Container(color: Colors.transparent)),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            '${result.winner.toDisplayString()} Wins',
                            style: context.textTheme.headlineLarge,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: modal.hide,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            result.reasonString,
                            style: context.textTheme.bodyMedium,
                          ),
                          Gap(16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                spacing: 16,
                                children: [
                                  SizedBox.square(
                                    dimension: 100,
                                    child: DiskImage(color: gameState.color),
                                  ),
                                  Text(
                                    user.username,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 64,
                                child: Center(
                                  child: Text(
                                    '${gameState.count(gameState.color)}',
                                    style: context.textTheme.displaySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Text(':', style: context.textTheme.displaySmall),
                              SizedBox(
                                width: 64,
                                child: Center(
                                  child: Text(
                                    '${gameState.count(gameState.color.opposite())}',
                                    style: context.textTheme.displaySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Column(
                                spacing: 16,
                                children: [
                                  SizedBox.square(
                                    dimension: 100,
                                    child: DiskImage(
                                      color: gameState.color.opposite(),
                                    ),
                                  ),
                                  Text(
                                    gameState.opponent.username,
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Gap(32),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                modal.hide();
                                modal.onClose();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Play Again'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
