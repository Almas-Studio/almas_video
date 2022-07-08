import 'package:almas_image/almas_image.dart';
import 'package:just_audio/just_audio.dart';

class AlmasAudio {
  final AudioSource source;
  final AlmasImage thumbnail;
  final String format;
  final String name;

  AlmasAudio({
    required this.source,
    required this.thumbnail,
    required this.format,
    required this.name
  });
}
