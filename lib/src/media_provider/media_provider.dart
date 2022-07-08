import 'dart:io';
import 'dart:typed_data';

import 'package:almas_video/src/models/file_progress.dart';

abstract class MediaProvider {
  Stream<FileProgress> resolve();

  Future<Uint8List> getBytes();

  Future<File> getFile() {
    return resolve()
        .firstWhere((p) => p.progress == 1.0 && p.file != null)
        .then((p) => p.file!);
  }
}
