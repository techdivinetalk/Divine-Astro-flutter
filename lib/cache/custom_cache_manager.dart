import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:flutter/foundation.dart'; // for compute function
import 'package:flutter/services.dart'; // for BackgroundIsolateBinaryMessenger

class _IsolateData {
  final RootIsolateToken token;
  final Function function;
  final SendPort answerPort;

  _IsolateData({
    required this.token,
    required this.function,
    required this.answerPort,
  });
}

class CustomCacheManager {
  // Private constructor
  CustomCacheManager._privateConstructor();

  // Singleton instance
  static final CustomCacheManager _instance =
      CustomCacheManager._privateConstructor();

  // Public factory constructor
  factory CustomCacheManager() {
    return _instance;
  }

  // Cache manager instance
  static final BaseCacheManager _cacheManager = DefaultCacheManager();

  // Method to get file
  Future<File> getFile(String url) async {
    FileInfo? fileInfo = await _cacheManager.getFileFromCache(url);

    if (fileInfo != null) {
      // Return the cached file
      log('File found in cache');
      return fileInfo.file;
    } else {
      // Download, cache and return the file using isolate
      log('File not found in cache');
      return await _downloadFileInIsolate(url);
    }
  }

  // Method to download file using an isolate
  Future<File> _downloadFileInIsolate(String url) async {
    // Download the file in a separate isolate
    return await computeIsolate(() => _downloadAndCacheFile(url));
  }

  Future<dynamic> computeIsolate(Future Function() function) async {
    final receivePort = ReceivePort();
    var rootToken = RootIsolateToken.instance!;
    await Isolate.spawn<_IsolateData>(
      _isolateEntry,
      _IsolateData(
        token: rootToken,
        function: function,
        answerPort: receivePort.sendPort,
      ),
    );
    return await receivePort.first;
  }

  void _isolateEntry(_IsolateData isolateData) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
    final answer = await isolateData.function();
    isolateData.answerPort.send(answer);
  }

  // Function to be run in an isolate
  static Future<File> _downloadAndCacheFile(String url) async {
    // Download the file
    File file = await DefaultCacheManager().getSingleFile(url);

    // Save the file in the cache
    await DefaultCacheManager().putFile(
      url,
      file.readAsBytesSync(),
      fileExtension: p.extension(url),
    );

    return file;
  }

  // Optional: Clear cache method
  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
