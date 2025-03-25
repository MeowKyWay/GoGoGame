import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/match_record.dart';
import 'package:gogogame_frontend/core/types/user_type.dart';
import 'package:gogogame_frontend/screens/home/record_page/player_row.dart';
import 'package:gogogame_frontend/widget/general/format_icon.dart';
import 'package:gogogame_frontend/widget/modal/app_modal.dart';
import 'package:gogogame_frontend/widget/modal/center_modal.dart';

class RecordModal extends AppModal {
  final Function() onClose;
  final MatchRecord record;

  RecordModal(super.context, {required this.onClose, required this.record});

  @override
  Widget build(BuildContext context, AppModal modal) {
    return _RecordModal(context: context, modal: this, record: record);
  }
}

class _RecordModal extends ConsumerWidget {
  final BuildContext context;
  final RecordModal modal;
  final MatchRecord record;

  const _RecordModal({
    required this.context,
    required this.modal,
    required this.record,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authState);

    late final UserType userPlayer;
    late final DiskColor userColor;
    late final int userScore;
    late final UserType opponentPlayer;
    late final DiskColor opponentColor;
    late final int opponentScore;

    if (record.blackPlayer?.id == user?.id) {
      userPlayer = record.blackPlayer!;
      userColor = DiskColor.black;
      userScore = record.blackScore;
      opponentPlayer = record.whitePlayer!;
      opponentColor = DiskColor.white;
      opponentScore = record.whiteScore;
    } else {
      userPlayer = record.whitePlayer!;
      userColor = DiskColor.white;
      userScore = record.whiteScore;
      opponentPlayer = record.blackPlayer!;
      opponentColor = DiskColor.black;
      opponentScore = record.blackScore;
    }

    return Theme(
      data: Theme.of(context),
      child: DefaultTextStyle(
        style: context.textTheme.labelMedium!,
        child: CenterModal(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: ColorScheme.of(context).surface,
                borderRadius: BorderRadius.circular(8),
              ),
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
                            Flexible(
                              child: Container(color: Colors.transparent),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                '${record.winner.toDisplayString()} Wins',
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
                                record.endReason,
                                style: context.textTheme.bodyMedium,
                              ),
                              Gap(16),
                              PlayerRow(
                                userColor: userColor,
                                userPlayer: userPlayer,
                                context: context,
                                userScore: userScore,
                                opponentScore: opponentScore,
                                opponentColor: opponentColor,
                                opponentPlayer: opponentPlayer,
                              ),

                              Column(
                                children: [
                                  FormatIcon(
                                    format: record.format,
                                    style: context.textTheme.labelLarge,
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
