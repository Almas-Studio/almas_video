import 'dart:io';
import 'dart:typed_data';

import 'package:almas_video/src/models/file_progress.dart';
import 'package:almas_video/src/video_provider/video_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MemoryVideo extends VideoProvider {
  final Uint8List bytes;
  final String format;

  MemoryVideo(this.bytes, {this.format = 'mp4'});

  @override
  Stream<FileProgress> resolve() async* {
    final uid = const Uuid().v4();
    final tdir = await getTemporaryDirectory();
    final tpath = join(tdir.path, '$uid.$format');
    final file = File(tpath);
    file.createSync();
    await file.writeAsBytes(bytes, flush: true);
    yield FileProgress(file, 1.0);
  }
}
