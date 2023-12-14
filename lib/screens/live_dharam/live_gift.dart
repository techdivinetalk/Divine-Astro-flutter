import "package:flutter/material.dart";
import "package:svgaplayer_flutter/parser.dart";
import "package:svgaplayer_flutter/player.dart";
import "package:svgaplayer_flutter/proto/svga.pb.dart";

class LiveGiftWidget extends StatefulWidget {
  static OverlayEntry? currentGiftEntries;
  static List<String> giftEntryPathCache = [];

  static void show(BuildContext context, String giftPath) {
    if (null != currentGiftEntries) {
      debugPrint("has gift displaying, cache $giftPath");

      giftEntryPathCache.add(giftPath);

      return;
    }

    currentGiftEntries = OverlayEntry(builder: (context) {
      return LiveGiftWidget(
        giftPath: giftPath,
        onRemove: () {
          if (currentGiftEntries?.mounted ?? false) {
            currentGiftEntries?.remove();
          }
          currentGiftEntries = null;

          if (giftEntryPathCache.isNotEmpty) {
            var nextGiftPath = giftEntryPathCache.first;
            giftEntryPathCache.removeAt(0);

            debugPrint("has gift cache, play $nextGiftPath");

            LiveGiftWidget.show(context, nextGiftPath);
          }
        },
      );
    });

    Overlay.of(context, rootOverlay: false).insert(currentGiftEntries!);
  }

  static bool clear() {
    if (currentGiftEntries?.mounted ?? false) {
      currentGiftEntries?.remove();
    }

    return true;
  }

  const LiveGiftWidget(
      {Key? key, required this.onRemove, required this.giftPath})
      : super(key: key);

  final VoidCallback onRemove;
  final String giftPath;

  @override
  State<LiveGiftWidget> createState() => LiveGiftWidgetState();
}

class LiveGiftWidgetState extends State<LiveGiftWidget>
    with SingleTickerProviderStateMixin {
  SVGAAnimationController? animationController;
  late Future<MovieEntity> movieEntity;

  @override
  void initState() {
    super.initState();
    movieEntity = SVGAParser.shared.decodeFromURL(widget.giftPath);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieEntity>(
      future: movieEntity,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          animationController ??= (SVGAAnimationController(vsync: this)
            ..videoItem = snapshot.data as MovieEntity
            ..forward().whenComplete(() {
              widget.onRemove();
            }));
          return SVGAImage(animationController!);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
