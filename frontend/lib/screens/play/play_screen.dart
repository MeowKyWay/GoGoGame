import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gogogame_frontend/core/constants/time_control.dart';
import 'package:gogogame_frontend/core/extensions/build_context_extension.dart';
import 'package:gogogame_frontend/core/services/game/game_state.dart';
import 'package:gogogame_frontend/screens/game/game_screen.dart';
import 'package:gogogame_frontend/widget/general/logo.dart';
import 'package:gogogame_frontend/widget/input/select_button.dart';

class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key});

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  TimeControl _timeControl = TimeControl.defaultTimeControl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Play')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Hero(tag: 'logo', child: Logo())),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                spacing: 8,
                children: [
                  Gap(56),
                  Row(
                    spacing: 8,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Time control'),
                            SizedBox(
                              height: 56,
                              child: SelectButton<TimeControl>(
                                items: TimeControl.timeControls,
                                prefixIcon: const Icon(Icons.timer),
                                onChanged: (value) {
                                  setState(() {
                                    _timeControl = value!;
                                  });
                                },
                                value: _timeControl,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: Hero(
                      tag: 'play',
                      child: FilledButton(
                        onPressed: () {
                          ref.read(gameStateProvider.notifier).resetMatch();
                          context.push(GameScreen(timeControl: _timeControl));
                        },
                        child: const Text('Play'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(56),
          ],
        ),
      ),
    );
  }
}
