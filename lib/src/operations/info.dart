import 'dart:async';
import 'dart:developer';

import 'package:almas_video/src/models/video_info.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffprobe_kit.dart';
import 'package:flutter/material.dart';

import '../media_provider/media_provider.dart';

Future<VideoInfo> resolveVideoInfo(MediaProvider video) async {
  final completer = Completer<VideoInfo>();
  final file = await video.getFile();
  log('file_path: ' + file.path);
  FFprobeKit.getMediaInformation(file.path).then((session) async {
    final information = session.getMediaInformation();
    if (information != null) {
      final properties = information.getAllProperties()!;
      final duration = double.parse(information.getDuration() ?? '5.000');

      final info = VideoInfo(
        size: Size(properties['streams'][0]['width'].toDouble(),
          properties['streams'][0]['height'].toDouble(),),
        length: Duration(
          seconds: duration.toInt(),
          milliseconds: ((duration.ceilToDouble() - duration) * 1000).toInt(),
        ),
      );
      completer.complete(info);
    } else {
      final failStackTrace = await session.getFailStackTrace();
      completer.completeError(failStackTrace ?? 'ffprobe error');
    }
  });

  return completer.future;
}
