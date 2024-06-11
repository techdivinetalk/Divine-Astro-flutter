import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class MyLottieWidget extends StatefulWidget {
  final String url;
  final EdgeInsets? padding;
  final Function(int) onTap;
  final BorderRadiusGeometry? borderRadius;

  const MyLottieWidget({
    Key? key,
    required this.url,
    this.padding,
    this.borderRadius,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MyLottieWidget> createState() => _MyLottieWidgetState();
}

class _MyLottieWidgetState extends State<MyLottieWidget>
    with AutomaticKeepAliveClientMixin {
  bool _isAnimationLoaded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isAnimationLoaded) {
          widget.onTap(0); // You may want to pass a different parameter here
        }
      },
      child: _isAnimationLoaded
          ? ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
        // clipBehavior: Clip.none,
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: Lottie.network(
            widget.url,
            fit: BoxFit.cover,
            height: 100,
            animate: true,
            // renderCache: RenderCache.raster,
          ),
        ),
      )
          : SizedBox(
        width: 200.0,
        height: 100.0,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.5),
          child: Container(
            width: 200.0,
            height: 100.0,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 35,
      height: 35,
      child: Center(
        child: CircularProgressIndicator(
          color: appColors.guideColor,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    try {

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isAnimationLoaded = true;
        });
      }
    } catch (e) {
      // Handle loading error
      print('Error loading Lottie animation: $e');
    }
  }

  @override
  bool get wantKeepAlive => true;
}