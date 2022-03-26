import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:almas_video/src/models/video_info.dart';
import 'package:almas_video/src/video_provider/video_provider.dart';
import 'package:ffmpeg_kit_flutter_video/ffprobe_kit.dart';
import 'package:flutter/material.dart';

Future<VideoInfo> resolveVideoInfo(VideoProvider video) async {
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
