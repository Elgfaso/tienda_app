import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Instancia única del reproductor
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playAudio(String name) async {
    try {
      // Reproduce el archivo desde la ruta de assets que configuraste
      await _audioPlayer.play(AssetSource('audios/$name.mp3'));
    } catch (e) {
      print('Error al reproducir sonido: $e');
    }
  }
}

class AudioNames{
  static String splash = 'splash';
  static String scanned = 'scanned';
}