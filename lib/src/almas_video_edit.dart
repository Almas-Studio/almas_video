import 'dart:async';
import 'dart:developer';

import 'package:almas_video/src/edit/video_input.dart';
import 'package:almas_video/src/almas_video.dart';
import 'package:almas_video/src/edit/video_overlay.dart';
import 'package:almas_video/src/models/file_progress.dart';
import 'package:almas_video/src/operations/temp_file.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';

class AlmasVideoEdit {
  final AlmasVideo source;
  final Duration duration;

  AlmasVideoEdit({
    required this.source,
    required this.duration,
  });

  final List<VideoOverlay> _overlays = [];

  List<VideoInput> get _inputs => [VideoInput(video: source)]
      .followedBy(_overlays.map(
        (e) => VideoInput(image: e.image, video: e.video),
      ))
      .toList();

  void addOverlay(VideoOverlay overlay) => _overlays.add(overlay);

  Stream<FileProgress> render() async* {
    final builder = StringBuffer();


    final inputs = await Future.wait(_inputs.map((i) => i.inputParam))
        .then((i) => i.join(" "));
    builder.write(inputs);

    if(_overlays.isNotEmpty) {
      // TODO
      final overlayComplexParam = _overlays.map((e) => e.filterParam).join(',');
      final overlayOrder = _overlays
          .asMap()
          .map((i, e) => MapEntry(i, e.getOrderParam(i + 1)))
          .values
          .join();

      const filter = " -filter_complex [0][1]overlay=0:0[out]";
      builder.write(filter);
    }

    final output = await getTemporaryFile('mp4');
    builder.write(' -c:v libx264 -pix_fmt yuv420p');
    if(_overlays.isNotEmpty){
      builder.write(' -map [out] -map 0:a?');
    }
    builder.write(' ${output.path}');

    final streamController = StreamController<FileProgress>();
    log('almas_video_edit $builder');
    await Future.delayed(const Duration(milliseconds: 10));
    FFmpegKit.executeAsync(builder.toString(), (session) async {
      final id = session.getSessionId()!;
      final state = await session.getState();
      if (state == SessionState.completed) {
        streamController.add(FileProgress(output, 1));
      } else if (state == SessionState.failed) {
        streamController
            .addError(await session.getFailStackTrace() ?? 'ffmpeg error');
      } else if (state == SessionState.created) {
        streamController.add(const FileProgress(null, 0));
      }
    }, (l) {
      log(l.getMessage());
    }, (statistics) {
      if (statistics.getTime() > 0) {
        log('almas_video_edit time: ' + statistics.getTime().toString());
        final progress = statistics.getTime() / duration.inMilliseconds;
        streamController.add(FileProgress(null, progress));
      }
    });

    yield* streamController.stream;
  }
}
