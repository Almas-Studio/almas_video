import 'package:almas_video/src/almas_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewport extends StatefulWidget {
  final AlmasVideo video;
  final bool playAllowed;

  const VideoViewport({
    Key? key,
    required this.video,
    required this.playAllowed,
  }) : super(key: key);

  @override
  State<VideoViewport> createState() => _VideoViewportState();
}

class _VideoViewportState extends State<VideoViewport> {
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
      _controller = VideoPlayerController.file(file,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        ..initialize().then((_) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        });
    });
  }

  @override
  void didUpdateWidget(covariant VideoViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playAllowed) {
      _controller?.play();
    } else {
      _controller?.pause();
    }
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
    _controller?.pause();
    super.deactivate();
  }
}
