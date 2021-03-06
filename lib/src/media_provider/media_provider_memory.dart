import 'dart:typed_data';

import 'package:almas_video/src/models/file_progress.dart';
import 'package:almas_video/src/operations/temp_file.dart';

import 'media_provider.dart';

class MemoryMedia extends MediaProvider {
  final Uint8List bytes;
  final String format;

  MemoryMedia(this.bytes, {this.format = 'mp4'});

  @override
  Stream<FileProgress> resolve() async* {
    final file = await getTemporaryFile();
    file.createSync();
    await file.writeAsBytes(bytes, flush: true);
    yield FileProgress(file, 1.0);
  }

  @override
  Future<Uint8List> getBytes() async => bytes;
}
