import 'package:almas_video/src/models/file_progress.dart';

abstract class VideoProvider {
  Stream<FileProgress> resolve();
}
