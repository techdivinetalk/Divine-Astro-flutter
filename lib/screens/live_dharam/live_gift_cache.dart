// import "package:flutter/material.dart";
// import "package:svgaplayer_flutter/parser.dart";
// import "package:svgaplayer_flutter/player.dart";
// import "package:svgaplayer_flutter/proto/svga.pb.dart";

// class LiveGiftCacheWidget extends StatefulWidget {
//   static OverlayEntry? currentGiftEntries;
//   static List<List<int>> giftEntryPathCache = [];

//   static void show(BuildContext context, List<int> giftPath) {
//     if (null != currentGiftEntries) {
//       debugPrint("has gift displaying, cache $giftPath");

//       giftEntryPathCache.add(giftPath);

//       return;
//     }

//     currentGiftEntries = OverlayEntry(builder: (context) {
//       return LiveGiftCacheWidget(
//         giftPath: giftPath,
//         onRemove: () {
//           if (currentGiftEntries?.mounted ?? false) {
//             currentGiftEntries?.remove();
//           }
//           currentGiftEntries = null;

//           if (giftEntryPathCache.isNotEmpty) {
//             var nextGiftPath = giftEntryPathCache.first;
//             giftEntryPathCache.removeAt(0);

//             debugPrint("has gift cache, play $nextGiftPath");

//             LiveGiftCacheWidget.show(context, nextGiftPath);
//           }
//         },
//       );
//     });

//     Overlay.of(context, rootOverlay: false).insert(currentGiftEntries!);
//   }

//   static bool clear() {
//     if (currentGiftEntries?.mounted ?? false) {
//       currentGiftEntries?.remove();
//     }

//     return true;
//   }

//   const LiveGiftCacheWidget(
//       {Key? key, required this.onRemove, required this.giftPath})
//       : super(key: key);

//   final VoidCallback onRemove;
//   final List<int> giftPath;

//   @override
//   State<LiveGiftCacheWidget> createState() => LiveGiftCacheWidgetState();
// }

// class LiveGiftCacheWidgetState extends State<LiveGiftCacheWidget>
//     with SingleTickerProviderStateMixin {
//   SVGAAnimationController? animationController;
//   late Future<MovieEntity> movieEntity;

//   @override
//   void initState() {
//     super.initState();
//     movieEntity = SVGAParser.shared.decodeFromBuffer(widget.giftPath);
//   }

//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<MovieEntity>(
//       future: movieEntity,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           animationController ??= (SVGAAnimationController(vsync: this)
//             ..videoItem = snapshot.data as MovieEntity
//             ..forward().whenComplete(() {
//               widget.onRemove();
//             }));
//           return SVGAImage(animationController!);
//         } else if (snapshot.hasError) {
//           return Text("${snapshot.error}");
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
