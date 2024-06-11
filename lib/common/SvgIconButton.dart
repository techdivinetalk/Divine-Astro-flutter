import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIconButton extends StatelessWidget {
  final SvgPicture svg;
  final VoidCallback onPressed;
  final double? height;
  final double? width;

  const SvgIconButton({
    super.key,
    required this.svg,
    required this.onPressed,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8.0),
        highlightColor: Colors.transparent,
        child: Ink(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SizedBox(
            height: height ?? 20,
            width: width ?? 20,
            child: svg,
          ),
        ),
      ),
    );
  }
}
