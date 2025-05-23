import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'settings_provider.dart';

class ScreenReaderHelper {
  static final FlutterTts _tts = FlutterTts();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> init() async {
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  static Future<void> readContent(String content, {bool force = false}) async {
    final settings = Provider.of<SettingsProvider>(navigatorKey.currentContext!, listen: false);
    if (settings.screenReaderEnabled || force) {
      await _tts.stop();
      await _tts.speak(content);
    }
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}