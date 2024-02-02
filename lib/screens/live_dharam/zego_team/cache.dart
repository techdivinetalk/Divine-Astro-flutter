import 'dart:io';
import 'dart:async';

import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class GiftCache {
  static final GiftCache _singleton = GiftCache._internal();

  factory GiftCache() {
    return _singleton;
  }

  GiftCache._internal();

  Future<List<int>> read({required String url}) async {
    List<int> result = kTransparentImage.toList();
    final FileInfo? info = await DefaultCacheManager().getFileFromCache(
      url,
      // ignoreMemCache: true,
    );
    if (info == null) {
      try {
        final Uri uri = Uri.parse(url);
        final http.Response response = await http.get(uri);
        if (response.statusCode == HttpStatus.ok) {
          result = response.bodyBytes.toList();
          // print("concurrentDownload downloadFile result:  $result");
          await DefaultCacheManager().putFile(url, response.bodyBytes);
          // print("concurrentDownload downloadFile cache: cached");
        } else {}
      } on Exception catch (e, s) {
        // print("concurrentDownload downloadFile Exception: $e $s");
      }
    } else {
      result = info.file.readAsBytesSync().toList();
    }

    return Future<List<int>>.value(result);
  }
}
