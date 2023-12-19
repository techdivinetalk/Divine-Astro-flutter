import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class GiftCache {
  static final GiftCache _singleton = GiftCache._internal();

  factory GiftCache() {
    return _singleton;
  }

  GiftCache._internal();

  int i = 0;

  Future<List<int>> downloadFile({required String url}) async {
    List<int> result = kTransparentImage.toList();

    final Directory cacheDir = await getTemporaryDirectory();

    final HiveCacheStore cacheStore = HiveCacheStore(
      cacheDir.path,
      hiveBoxName: "hive_box_divine_astrologer",
    );

    final CacheOptions customCacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.forceCache,
      priority: CachePriority.high,
      maxStale: const Duration(minutes: 5),
      hitCacheOnErrorExcept: [401, 404],
      keyBuilder: (request) => request.uri.toString(),
      allowPostMethod: false,
    );

    final Dio customDio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(options: customCacheOptions),
      );

    Options options = Options(responseType: ResponseType.bytes);

    Response res = await customDio.get(url, options: options);

    if (res.statusCode == HttpStatus.ok) {
      final List<int> listOfInt = res.data;
      result = listOfInt;
    } else {}

    return Future<List<int>>.value(result);
  }
}
