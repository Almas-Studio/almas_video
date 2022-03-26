import 'dart:io';

import 'package:almas_video/src/models/file_progress.dart';
import 'package:almas_video/src/video_provider/video_provider.dart';

class FileVideo extends VideoProvider {

  final File file;

  FileVideo(this.file);

  @override
  Stream<FileProgress> resolve() async*{
    yield FileProgress(file, 1.0);
  }
}
