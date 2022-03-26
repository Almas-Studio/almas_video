import 'dart:io';

import 'package:almas_video/src/models/file_progress.dart';

abstract class VideoProvider {
  Stream<FileProgress> resolve();

  Future<File> getFile() {
    return resolve()
        .firstWhere((p) => p.progress == 1.0 && p.file != null)
        .then((p) => p.file!);
  }
}
