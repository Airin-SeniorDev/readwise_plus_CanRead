@JS()
library tts_web_service;

import 'package:js/js.dart';

@JS('speakText')
external void speakTextJs(String text, double rate);

class TTSWebService {
  static void speak(String text, double rate) {
    speakTextJs(text, rate);
  }
}
