import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class SvgaPicture extends StatefulWidget {
  final String image;
  final BoxFit fit;
  final bool repeat;
  final bool reverse;
  final VoidCallback? onTap;

  const SvgaPicture({
    Key? key,
    required this.image,
    this.fit = BoxFit.cover,
    this.repeat = true,
    this.reverse = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<SvgaPicture> createState() => _SvgaPictureState();
}

class _SvgaPictureState extends State<SvgaPicture>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late SVGAAnimationController _animationController;
  bool _isLoading = true;
  bool _animationLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = SVGAAnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _loadAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAnimation() async {
    try {
      if (!_animationLoaded) {
        final videoItem = await _loadVideoItem(widget.image);
        if (mounted) {
          setState(() {
            _isLoading = false;
            _animationController.videoItem = videoItem;
            _playAnimation();
            _animationLoaded = true;
          });
        }
      }
    } catch (e) {
      print('Error loading SVGA animation: $e');
    }
  }

  void _playAnimation() {
    if (_animationController.isCompleted) {
      _animationController.reset();
    }
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Call the onTap callback if provided
      child: _isLoading
          ? CircularProgressIndicator(color: appColors.guideColor).centered()
          : SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SVGAImage(_animationController),
      ),
    );
  }

  Future _loadVideoItem(String image) {
    return image.startsWith(RegExp(r'https?://'))
        ? SVGAParser.shared.decodeFromURL(image)
        : SVGAParser.shared.decodeFromAssets(image);
  }

  @override
  bool get wantKeepAlive => true;
}
class SvgImageBanner extends StatelessWidget {
  final String imageUrl;
  final Function() onTap;

  const SvgImageBanner({
    Key? key,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SvgPicture.network(
        imageUrl,
        fit: BoxFit.fill,
      ),
    );
  }
}