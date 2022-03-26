import 'dart:async';
import 'dart:io';

import 'package:almas_video/src/models/file_progress.dart';
import 'package:almas_video/src/video_provider/video_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:uuid/uuid.dart';

class CachedNetworkVideo extends VideoProvider {
  final String url;
  final Map<String, String>? headers;
  final String? cacheKey;

  CachedNetworkVideo(
    this.url, {
    this.headers,
    this.cacheKey,
  });

  @override
  Stream<FileProgress> resolve() async* {
    final key = cacheKey ?? const Uuid().v4();
    try {
      var stream = DefaultCacheManager().getFileStream(
        url,
        withProgress: true,
        headers: headers,
        key: cacheKey,
      );

      await for (var result in stream) {
        if (result is DownloadProgress) {
          yield FileProgress(
            null,
            result.downloaded / (result.totalSize ?? 1000000),
          );
        }
        if (result is FileInfo) {
          yield FileProgress(result.file, 1.0);
        }
      }
    } catch (e) {
      scheduleMicrotask(() {
        DefaultCacheManager().removeFile(key);
      });
      rethrow;
    }
  }
}
