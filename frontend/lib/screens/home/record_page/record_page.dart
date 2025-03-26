import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/auth/auth_service_provider.dart';
import 'package:gogogame_frontend/core/services/record_provider.dart';
import 'package:gogogame_frontend/core/types/game_type.dart';
import 'package:gogogame_frontend/core/types/match_record.dart';
import 'package:gogogame_frontend/screens/home/home_screen.dart';
import 'package:gogogame_frontend/screens/home/record_page/record_modal.dart';

class Record extends ConsumerStatefulWidget implements AppHomePage {
  const Record({super.key});

  @override
  Widget get title => const Text('Records');

  @override
  ConsumerState<Record> createState() => _RecordState();
}

class _RecordState extends ConsumerState<Record>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final List<MatchRecord> records = ref.watch(recordProvider);
    final user = ref.watch(authState);
    if (ref.read(recordProvider.notifier).isLoading) {
      return Center(
        child: CircularProgressIndicator(color: context.colorScheme.onSurface),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];

        bool win =
            record.winner == Winner.black &&
                record.blackPlayer?.id == user?.id ||
            record.winner == Winner.white && record.whitePlayer?.id == user?.id;

        String label =
            '${record.blackPlayer?.id == user?.id ? 'You' : record.blackPlayer?.username} vs ${record.whitePlayer?.id == user?.id ? 'You' : record.whitePlayer?.username}';

        return ListTile(
          onTap: () {
            RecordModal modal = RecordModal(
              context,
              vsync: this,
              onClose: () {},
              record: record,
            );
            modal.show();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: FittedBox(
            child: Column(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: context.colorScheme.secondary,
                ),
                Text(
                  record.format.toString(),
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          title: Text(label),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  win
                      ? context.colorScheme.secondary
                      : context.colorScheme.error,
            ),
            child: Icon(
              win ? Icons.add : Icons.remove,
              color: context.colorScheme.surface,
            ),
          ),
        );
      },
      separatorBuilder:
          (context, index) => Divider(color: context.colorScheme.primary),
    );
  }
}
