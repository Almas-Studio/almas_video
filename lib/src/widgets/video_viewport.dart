import 'package:almas_video/src/almas_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

class VideoViewport extends StatefulWidget {
  final AlmasVideo video;

  const VideoViewport({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<VideoViewport> createState() => _VideoViewportState();
}

class _VideoViewportState extends VisibilityAwareState<VideoViewport> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    widget.video.video
        .resolve()
        .lastWhere((p) => p.progress == 1)
        .then((fileProgress) => fileProgress.file)
        .then((file) {
      if (file == null) throw 'Video File is null';
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null && _controller!.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
        : Container();
  }


  @override
  void deactivate() {
    super.deactivate();
    _controller?.pause();
  }

  @override
  void onVisibilityChanged(WidgetVisibility visibility) {
    super.onVisibilityChanged(visibility);
    switch(visibility){
      case WidgetVisibility.VISIBLE:
        _controller?.play();
        break;
      case WidgetVisibility.INVISIBLE:
        _controller?.pause();
        break;
      case WidgetVisibility.GONE:
        _controller?.pause();
        break;
    }
  }
}
