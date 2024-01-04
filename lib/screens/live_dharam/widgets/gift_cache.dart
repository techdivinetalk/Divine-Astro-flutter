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

  int count = 1;

  Future<List<int>> downloadFile({required String url, required int ln}) async {
    List<int> result = kTransparentImage.toList();
    final FileInfo? info = await DefaultCacheManager().getFileFromCache(
      url,
      ignoreMemCache: true,
    );
    if (info == null) {
      try {
        final Uri uri = Uri.parse(url);
        final http.Response response = await http.get(uri);
        if (response.statusCode == HttpStatus.ok) {
          result = response.bodyBytes.toList();
          //print("concurrentDownload downloadFile result: $count/$ln: $result");
          await DefaultCacheManager().putFile(url, response.bodyBytes);
          //print("concurrentDownload downloadFile cache: $count/$ln: cached");
        } else {}
      } on Exception catch (e, s) {
        //print("concurrentDownload downloadFile Exception: $count/$ln: $e $s");
      }
    } else {
      result = info.file.readAsBytesSync().toList();
    }
    count++;
    return Future<List<int>>.value(result);
  }
}
