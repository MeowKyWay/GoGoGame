import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/audio_service.dart';

final gameSoundEffectService = Provider((ref) => GameSoundEffectService());

class GameSoundEffectService {
  void playDiskSound() {
    Random random = Random();
    int soundIndex = random.nextInt(4) + 1;
    AudioService().playLocalAudio('sounds/disk_$soundIndex.mp3');
  }
}
