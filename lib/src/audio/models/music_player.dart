import 'package:almas_video/almas_video.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer with ChangeNotifier{
  final player = AudioPlayer();

  void setSource(AlmasAudio audio) {
    final source = audio.source;
    if (source is FileMedia) {
      player.setFilePath(source.file.path);
    } else if (source is CachedNetworkMedia) {
      final plSource = LockCachingAudioSource(
        Uri.parse(source.url),
        headers: source.headers,
        tag: source.cacheKey,
      );
      player.setAudioSource(plSource);
    }
  }


}
