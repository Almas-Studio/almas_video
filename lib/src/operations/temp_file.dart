import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getTemporaryFile([String? extension, String? fileName]) async{
  final uid = fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
  final tdir = await getTemporaryDirectory();
  final name = extension==null ? uid : '$uid.$extension';
  final tpath = join(tdir.path, name);
  final file = File(tpath);
  return file;
}