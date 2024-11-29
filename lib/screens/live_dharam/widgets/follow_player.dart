import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum FollowPlayerSource {
  url,
  asset,
  bytes,
}

class FollowPlayerData {
  FollowPlayerSource source = FollowPlayerSource.asset;
  dynamic value = '';
  String name = '';

  FollowPlayerData(
    this.source,
    this.value,
    this.name,
  );

  @override
  String toString() {
    return 'GiftPlayerData:{'
        'source:$source, '
        'value:$value, '
        'name:$name, '
        '}';
  }
}

class FollowPlayerWidget extends StatefulWidget {
  const FollowPlayerWidget({
    Key? key,
    required this.onRemove,
    required this.data,
  }) : super(key: key);

  final VoidCallback onRemove;
  final FollowPlayerData data;

  @override
  State<FollowPlayerWidget> createState() => FollowPlayerWidgetState();
}

class FollowPlayerWidgetState extends State<FollowPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    debugPrint('load ${widget.data} begin:${DateTime.now().toString()}');
    switch (widget.data.source) {
      case FollowPlayerSource.url:
        // Replace with your Lottie file URL
        _animationController = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 5),
        );
        break;
      case FollowPlayerSource.asset:
        _animationController = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 5),
        );
        break;
      case FollowPlayerSource.bytes:
        _animationController = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 5),
        );
        break;
    }
  }

  @override
  void dispose() {
    widget.onRemove();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LottieBuilder(
            lottie: lottieProviderFunction(),
            controller: _animationController,
            onLoaded: (composition) {
              _animationController
                ..duration = composition.duration
                ..forward().whenComplete(() {
                  widget.onRemove();
                });
            },
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Followed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  LottieProvider lottieProviderFunction() {
    LottieProvider lottieProvider = NetworkLottie("");
    switch (widget.data.source) {
      case FollowPlayerSource.url:
        lottieProvider = NetworkLottie(widget.data.value);
        break;
      case FollowPlayerSource.asset:
        lottieProvider = AssetLottie(widget.data.value);
        break;
      case FollowPlayerSource.bytes:
        lottieProvider = MemoryLottie(widget.data.value);
        break;
    }
    return lottieProvider;
  }
}

class FollowPlayer {
  static final FollowPlayer _singleton = FollowPlayer._internal();

  factory FollowPlayer() {
    return _singleton;
  }

  FollowPlayer._internal();

  OverlayEntry? currentGiftEntries;
  List<FollowPlayerData> giftEntryPathCache = [];

  void play(
    BuildContext context,
    FollowPlayerData data,
  ) {
    if (null != currentGiftEntries) {
      debugPrint("has gift displaying, cache, data:$data");
      giftEntryPathCache.add(data);
      return;
    }

    currentGiftEntries = OverlayEntry(builder: (context) {
      return FollowPlayerWidget(
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
