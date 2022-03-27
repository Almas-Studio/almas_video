import 'dart:io';

import 'package:almas_image/almas_image.dart';
import 'package:almas_video/src/almas_video.dart';
import 'package:almas_video/src/operations/almas_image_ext.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VideoInput {
  final AlmasImage? image;
  final AlmasVideo? video;

  const VideoInput({this.image, this.video})
      : assert(image != null || video != null);

  Future<File> get file => video?.video.getFile() ?? image!.getFile();

  Future<String> get inputParam async => '-i ${(await file).path}';
}
