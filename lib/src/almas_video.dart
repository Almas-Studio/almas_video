import 'package:almas_video/src/video_provider/video_provider.dart';
import 'package:almas_video/src/video_provider/video_provider_network.dart';

class AlmasVideo {
  final VideoProvider video;

  const AlmasVideo(this.video);

  factory AlmasVideo.network(String url) {
    return AlmasVideo(CachedNetworkVideo(url));
  }
}
