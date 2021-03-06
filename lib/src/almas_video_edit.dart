import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:almas_video/src/edit/video_input.dart';
import 'package:almas_video/src/almas_video.dart';
import 'package:almas_video/src/edit/video_overlay.dart';
import 'package:almas_video/src/models/file_progress.dart';
import 'package:almas_video/src/operations/temp_file.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/session_state.dart';

class AlmasVideoEdit {
  final VideoInput source;
  final Duration duration;
  final File? output;
  final String encoder;

  AlmasVideoEdit({
    required this.source,
    required this.duration,
    this.output,
    this.encoder = 'libx264',
  });

  final List<VideoOverlay> _overlays = [];

  ///
  /// Map Inputs
  ///
  List<VideoInput> get _inputs => [source]
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

    if (_overlays.isNotEmpty) {
      ///
      /// pre process overlays
      ///
      final overlayInPipes = List.generate(_overlays.length, (i) => '${i + 1}');
      final overlayProcessedPipes = overlayInPipes.map((i) => 'p$i').toList();

      final processCommands = List.generate(
          _overlays.length,
          (i) => '[${overlayInPipes[i]}]'
              '${_overlays[i].preProcessingParam}'
              '[${overlayProcessedPipes[i]}]');

      ///
      /// Apply Overlay
      ///
      final backgroundInPipe =
          List.generate(_overlays.length, (i) => i == 0 ? '0' : 'out$i');
      final outPipes = List.generate(_overlays.length,
          (i) => i == _overlays.length - 1 ? 'out' : 'out${i + 1}');

      final overlayCommands = List.generate(
        _overlays.length,
        (i) => '[${backgroundInPipe[i]}][${overlayProcessedPipes[i]}]'
            '${_overlays[i].filterParam}[${outPipes[i]}]',
      );

      final filter = " -filter_complex ${processCommands.followedBy(overlayCommands).join(';')}";
      builder.write(filter);
    }

    builder.write(' -c:v $encoder -pix_fmt yuv420p');
    if (_overlays.isNotEmpty) {
      builder.write(' -map [out] -map 1:a?'); //
    }

    ///
    /// Video Duration
    ///
    final length =
        '${duration.inHours}:${duration.inMinutes % 60}:${duration.inSeconds % 60}';
    builder.write(' -t $length');

    ///
    /// Output File
    ///
    final outFile = output ?? await getTemporaryFile('mp4');
    if (outFile.existsSync()) {
      outFile.deleteSync();
    }
    builder.write(' ${outFile.path}');

    log(builder.toString());

    FFmpegSession? _session;
    final streamController = StreamController<FileProgress>.broadcast(
      onCancel: () => _session?.cancel(),
    );
    FFmpegKit.executeAsync(builder.toString(), (session) async {
      _session = session;
      final id = session.getSessionId()!;
      final state = await session.getState();
      if (state == SessionState.completed) {
        streamController.add(FileProgress(outFile, 1));
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
        final progress = statistics.getTime() / duration.inMilliseconds;
        streamController.add(FileProgress(null, progress));
      }
    });

    yield* streamController.stream;
  }
}
