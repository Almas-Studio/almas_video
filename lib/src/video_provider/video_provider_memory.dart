import 'dart:typed_data';

import 'package:almas_video/src/models/file_progress.dart';
import 'package:almas_video/src/operations/temp_file.dart';
import 'package:almas_video/src/video_provider/video_provider.dart';

class MemoryVideo extends VideoProvider {
  final Uint8List bytes;
  final String format;

  MemoryVideo(this.bytes, {this.format = 'mp4'});

  @override
  Stream<FileProgress> resolve() async* {
    final file = await getTemporaryFile();
    file.createSync();
    await file.writeAsBytes(bytes, flush: true);
    yield FileProgress(file, 1.0);
  }
}
