import 'dart:ui';

import 'package:almas_image/almas_image.dart';
import 'package:almas_video/almas_video.dart';

class VideoOverlay {
  final AlmasVideo? video;
  final AlmasImage? image;

  //final Duration? duration;
  final Offset offset;
  //final Size? size;

  const VideoOverlay({
    this.video,
    this.image,
    //this.duration,
    this.offset = const Offset(0, 0),
    //this.size,
  }) : assert(video != null || image != null, 'should have an image or video');

  String get filterParam => "overlay=${offset.dx.toInt()}:${offset.dy.toInt()}";

  String getOrderParam(int i) => '[$i]';
}
