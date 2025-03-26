import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/audio_service.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';

final gameSoundEffectService = Provider(
  (ref) => GameSoundEffectService(config: ref.watch(configService)),
);

class GameSoundEffectService {
  final AppConfig config;

  GameSoundEffectService({required this.config});

  void playDiskSound() {
    if (config.isMuted) return;

    dev.log(config.isMuted.toString());
    Random random = Random();
    int soundIndex = random.nextInt(4) + 1;
    AudioService().playLocalAudio('sounds/disk_$soundIndex.mp3');
  }
}
