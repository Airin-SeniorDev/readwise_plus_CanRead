@JS()
library tts_web_service;

import 'package:js/js.dart';
import 'dart:js' as js;

@JS('speakText')
external void speakText(String text, String lang, double rate);

class TTSWebService {
  static void speak(String text, double rate, String langCode) {
    js.context.callMethod('speakText', [text, langCode, rate]);
  }
}
