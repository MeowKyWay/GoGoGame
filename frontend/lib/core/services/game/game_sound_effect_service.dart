import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gogogame_frontend/core/services/audio_service.dart';
import 'package:gogogame_frontend/core/services/config_service.dart';

final gameSoundEffectService = Provider(
  (ref) => GameSoundEffectService(config: ref.watch(configService)),
);

class GameSoundEffectService {
  final AppConfig config;
  int _currentPlayingSounds = 0; // Keep track of how many sounds are playing.

  final AudioService audioService = AudioService();

  GameSoundEffectService({required this.config});

  // Maximum number of sounds that can be played at once.
  static const int maxSimultaneousSounds = 1;

  void playDiskSound() {
    if (config.isMuted) return;

    // Prevent playing more than 2 sounds simultaneously.
    if (_currentPlayingSounds >= maxSimultaneousSounds) {
      return; // Do nothing if we are already playing 2 sounds.
    }

    _currentPlayingSounds++; // Increment count of playing sounds.
    Random random = Random();
    int soundIndex = random.nextInt(4) + 1;

    audioService
        .playLocalAudio('sounds/disk_$soundIndex.mp3')
        .then((_) {
          _currentPlayingSounds--; // Decrement count once the sound finishes playing.
        })
        .catchError((error) {
          _currentPlayingSounds--; // Decrement if there is an error.
        });
  }
}
