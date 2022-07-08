import 'package:almas_image/almas_image.dart';
import 'package:almas_video/almas_video.dart';

class AlmasAudio {
  final MediaProvider source;
  final String format;
  final String name;

  const AlmasAudio({
    required this.source,
    required this.name,
    required this.format,
  });
}
