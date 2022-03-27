import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<File> getTemporaryFile([String? extension]) async{
  final uid = const Uuid().v4();
  final tdir = await getTemporaryDirectory();
  final name = extension==null ? uid : '$uid.$extension';
  final tpath = join(tdir.path, name);
  final file = File(tpath);
  return file;
}