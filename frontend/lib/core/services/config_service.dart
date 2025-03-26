import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gogogame_frontend/core/themes/game_theme.dart';

final configService = StateNotifierProvider<ConfigService, AppConfig>((ref) {
  return ConfigService()..loadConfig();
});

class ConfigService extends StateNotifier<AppConfig> {
  static const _storage = FlutterSecureStorage();
  static const _key = "app_config";

  ConfigService() : super(AppConfig.defaultConfig());

  Future<void> loadConfig() async {
    final jsonString = await _storage.read(key: _key);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(jsonString);
        state = AppConfig.fromJson(data);
      } catch (e) {
        log("Error loading config: $e");
      }
    }
  }

  Future<void> saveConfig() async {
    final jsonString = jsonEncode(state.toJson());
    await _storage.write(key: _key, value: jsonString);
  }

  void updateConfig(AppConfig newConfig) {
    state = newConfig;
    saveConfig();
  }

  void toggleMute() {
    updateConfig(state.copyWith(isMuted: !state.isMuted));
  }

  void toggleDarkMode() {
    updateConfig(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void changeGameTheme(GameTheme newTheme) {
    updateConfig(state.copyWith(gameTheme: newTheme));
  }
}

class AppConfig {
  bool isMuted;
  bool isDarkMode;
  GameTheme gameTheme;

  AppConfig({
    required this.isMuted,
    required this.isDarkMode,
    required this.gameTheme,
  });

  factory AppConfig.defaultConfig() {
    return AppConfig(
      isMuted: false,
      isDarkMode: false,
      gameTheme: defaultGameTheme,
    );
  }

  AppConfig copyWith({bool? isMuted, bool? isDarkMode, GameTheme? gameTheme}) {
    return AppConfig(
      isMuted: isMuted ?? this.isMuted,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      gameTheme: gameTheme ?? this.gameTheme,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isMuted': isMuted,
      'isDarkMode': isDarkMode,
      'gameTheme': gameTheme.toJson(),
    };
  }

  factory AppConfig.fromJson(Map<String, dynamic> data) {
    return AppConfig(
      isMuted: data['isMuted'],
      isDarkMode: data['isDarkMode'],
      gameTheme: GameTheme.fromJson(data['gameTheme']),
    );
  }
}
