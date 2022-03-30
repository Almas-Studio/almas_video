import 'dart:typed_data';

import 'package:almas_video/src/video_provider/video_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<Uint8List> resolveVideoThumbnail(VideoProvider video) async {
  final file = await video.getFile();
  final bytes = await VideoThumbnail.thumbnailData(
    video: file.path,
    quality: 100,
  );
  if(bytes==null){
    throw 'video thumbnail error';
  }
  return bytes;
}
