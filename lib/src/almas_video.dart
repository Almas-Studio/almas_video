import 'dart:typed_data';

import 'package:almas_video/src/models/video_info.dart';
import 'package:almas_video/src/operations/info.dart';

import 'media_provider/media_provider.dart';
import 'media_provider/media_provider_network.dart';
import 'operations/thumbnail.dart';

class AlmasVideo {
  final MediaProvider video;

  const AlmasVideo(this.video);

  factory AlmasVideo.network(String url) {
    return AlmasVideo(CachedNetworkMedia(url));
  }

  Future<VideoInfo> get info => resolveVideoInfo(video);

  Future<Uint8List> get thumbnail => resolveVideoThumbnail(video);
}
