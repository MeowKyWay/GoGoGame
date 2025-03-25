import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Play audio from URL
  Future<void> playAudio(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      throw Exception("Failed to play audio: $e");
    }
  }

  // Play local audio file from assets
  Future<void> playLocalAudio(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      throw Exception("Failed to play local audio: $e");
    }
  }

  // Pause the currently playing audio
  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      throw Exception("Failed to pause audio: $e");
    }
  }

  // Stop the currently playing audio
  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      throw Exception("Failed to stop audio: $e");
    }
  }

  // Dispose the audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
