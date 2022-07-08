import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

import '../media_provider/media_provider.dart';

Future<Uint8List> resolveVideoThumbnail(MediaProvider video) async {
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
