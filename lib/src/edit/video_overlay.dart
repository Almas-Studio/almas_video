import 'dart:ui';

import 'package:almas_image/almas_image.dart';
import 'package:almas_video/almas_video.dart';

class VideoOverlay {
  final AlmasVideo? video;
  final AlmasImage? image;

  final Duration start;
  final Duration? duration;
  final Offset offset;
  final Size? size;
  final RRect? crop;

  const VideoOverlay({
    this.video,
    this.image,
    this.start = const Duration(seconds: 0),
    this.duration,
    this.offset = const Offset(0, 0),
    this.size,
    this.crop,
  }) : assert(video != null || image != null, 'should have an image or video');

  VideoInput get asInput => VideoInput(image: image, video: video);

  String get preProcessingParam => '$cropParam$sizeParam';

  String get filterParam => '$offsetParam$optionalDuration';

  String get cropParam => crop == null
      ? ''
      : 'crop=${crop!.width.toInt()}:${crop!.height.toInt()}'
          ':${crop!.top.toInt()}:${crop!.left.toInt()},';

  String get offsetParam => "overlay=${offset.dx.toInt()}:${offset.dy.toInt()}";

  String get optionalDuration => duration == null
      ? ''
      : ":enable='between(t,${start.inSeconds},"
          "${duration!.inSeconds + start.inSeconds})'";

  String get sizeParam => size == null
      ? 'null'
      : 'scale=${size!.width.toInt()}:${size!.height.toInt()}';
}
