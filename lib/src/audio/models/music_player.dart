import 'package:almas_video/almas_video.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MusicPlayer with ChangeNotifier {
  final player = AudioPlayer();
  AlmasAudio? audio;

  void setSource(AlmasAudio audio, {int? id, String? album, String? art}) {
    this.audio = audio;
    player.setLoopMode(LoopMode.one);
    final source = audio.source;
    if (source is FileMedia) {
      player.setFilePath(source.file.path);
    } else if (source is CachedNetworkMedia) {
      final plSource = LockCachingAudioSource(
        Uri.parse(source.url),
        headers: source.headers,
        tag: MediaItem(
          id: (id ?? audio.name.hashCode).toString(),
          title: audio.name,
          album: album,
          artUri: Uri.tryParse(art ?? '-'),
        ),
      );
      player.setAudioSource(plSource);
    }
  }
}
