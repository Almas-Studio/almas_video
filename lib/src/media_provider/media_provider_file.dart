import 'dart:io';
import 'dart:typed_data';

import 'package:almas_video/src/models/file_progress.dart';

import 'media_provider.dart';

class FileVideo extends MediaProvider {

  final File file;

  FileVideo(this.file);

  @override
  Stream<FileProgress> resolve() async*{
    yield FileProgress(file, 1.0);
  }

  @override
  Future<Uint8List> getBytes() => file.readAsBytes();
}
