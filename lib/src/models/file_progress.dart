import 'dart:io';

class FileProgress {
  final File? file;
  final double progress;

  const FileProgress(this.file, this.progress);

  bool get complete => progress == 1.0 && file != null;
}