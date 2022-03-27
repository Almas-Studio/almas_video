import 'dart:io';

import 'package:almas_image/almas_image.dart';
import 'package:almas_video/src/operations/temp_file.dart';

extension AlmasImageX on AlmasImage {

  Future<File> getFile() async {
    final file = await getTemporaryFile();
    file.createSync(recursive: true);
    await file.writeAsBytes(await bytes, flush: true);
    return file;
  }

}