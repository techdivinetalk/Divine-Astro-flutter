import 'package:divine_astrologer/screens/live_dharam/zego_team/cache.dart';
import 'package:flutter/material.dart';

import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:svgaplayer_flutter/proto/svga.pb.dart';

enum GiftPlayerSource {
  url,
  asset,
  bytes,
}

class GiftPlayerData {
  GiftPlayerSource source = GiftPlayerSource.asset;
  dynamic value = '';

  GiftPlayerData(
    this.source,
    this.value,
  );

  @override
  String toString() {
    return 'GiftPlayerData:{'
        'source:$source, '
        'value:$value, '
        '}';
  }
}

class GiftPlayerWidget extends StatefulWidget {
  const GiftPlayerWidget({
    Key? key,
    required this.onRemove,
    required this.data,
  }) : super(key: key);

  final VoidCallback onRemove;
  final GiftPlayerData data;

  @override
  State<GiftPlayerWidget> createState() => GiftPlayerWidgetState();
}

class GiftPlayerWidgetState extends State<GiftPlayerWidget>
    with SingleTickerProviderStateMixin {
  SVGAAnimationController? animationController;

  final loadedNotifier = ValueNotifier<bool>(false);
  late Future<MovieEntity> movieEntity;

  @override
  void initState() {
    super.initState();

    debugPrint('load ${widget.data} begin:${DateTime.now().toString()}');
    switch (widget.data.source) {
      case GiftPlayerSource.url:
        GiftCache()
            .read(url: widget.data.value as String? ?? '')
            .then((byteData) {
          movieEntity = SVGAParser.shared.decodeFromBuffer(byteData);

          loadedNotifier.value = true;
        });
        // movieEntity = SVGAParser.shared.decodeFromURL();
        break;
      case GiftPlayerSource.asset:
        movieEntity = SVGAParser.shared
            .decodeFromAssets(widget.data.value as String? ?? '');

        loadedNotifier.value = true;
        break;
      case GiftPlayerSource.bytes:
        movieEntity = SVGAParser.shared
            .decodeFromBuffer(widget.data.value as List<int>? ?? []);

        loadedNotifier.value = true;
        break;
    }
  }

  @override
  void dispose() {
    widget.onRemove();

    if (animationController?.isAnimating ?? false) {
      animationController?.stop();
    }
    animationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loadedNotifier,
      builder: (context, isLoaded, _) {
        if (!isLoaded) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }

        debugPrint('load ${widget.data} done:${DateTime.now().toString()}');

        return FutureBuilder<MovieEntity>(
          future: movieEntity,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              animationController ??= (SVGAAnimationController(vsync: this)
                ..videoItem = snapshot.data as MovieEntity
                ..forward().whenComplete(() {
                  widget.onRemove();
                }));
              return SVGAImage(
                animationController!,
                // fit: BoxFit.fill,
                fit: BoxFit.cover,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }
}

class ZegoGiftPlayer {
  static final ZegoGiftPlayer _singleton = ZegoGiftPlayer._internal();

  factory ZegoGiftPlayer() {
    return _singleton;
  }

  ZegoGiftPlayer._internal();

  OverlayEntry? currentGiftEntries;
  List<GiftPlayerData> giftEntryPathCache = [];

  void play(
    BuildContext context,
    GiftPlayerData data,
  ) {
    if (null != currentGiftEntries) {
      debugPrint("has gift displaying, cache, data:$data");

      giftEntryPathCache.add(data);

      return;
    }

    currentGiftEntries = OverlayEntry(builder: (context) {
      return GiftPlayerWidget(
        data: data,
        onRemove: () {
          if (currentGiftEntries?.mounted ?? false) {
            currentGiftEntries?.remove();
          }
          currentGiftEntries = null;

          if (giftEntryPathCache.isNotEmpty) {
            var nextGiftPath = giftEntryPathCache.first;
            giftEntryPathCache.removeAt(0);

            debugPrint("has gift cache, play $nextGiftPath");

            play(context, nextGiftPath);
          }
        },
      );
    });

    Overlay.of(context, rootOverlay: false).insert(currentGiftEntries!);
  }

  bool clear() {
    if (currentGiftEntries?.mounted ?? false) {
      currentGiftEntries?.remove();
    }

    currentGiftEntries = null;

    return true;
  }
}
