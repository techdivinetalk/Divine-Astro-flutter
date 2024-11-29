library custom_widget_marquee;

import 'package:flutter/material.dart';

enum DirectionOption { oneDirection, twoDirection }

class CustomWidgetMarquee extends StatelessWidget {
  final Widget child;
  final TextDirection textDirection;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;
  final DirectionOption directionOption;
  final Curve forwardAnimation;
  final Curve backwardAnimation;
  final bool autoRepeat;

  CustomWidgetMarquee({
    Key? key,
    required this.child,
    this.direction = Axis.horizontal,
    this.textDirection = TextDirection.ltr,
    this.animationDuration = const Duration(seconds: 2),
    this.backDuration = const Duration(seconds: 10),
    this.pauseDuration = const Duration(seconds: 1),
    this.directionOption = DirectionOption.oneDirection,
    this.forwardAnimation = Curves.linear,
    this.backwardAnimation = Curves.linear,
    this.autoRepeat = true,
  }) : super(key: key);

  final ScrollController _sCtrl = ScrollController();

  scroll(bool repeated) async {
    do {
      if (_sCtrl.hasClients) {
        await Future.delayed(pauseDuration);
        if (_sCtrl.hasClients) {
          await _sCtrl.animateTo(
            _sCtrl.position.maxScrollExtent,
            duration: animationDuration,
            curve: forwardAnimation,
          );
        }
        await Future.delayed(pauseDuration);
        if (_sCtrl.hasClients) {
          switch (directionOption) {
            case DirectionOption.oneDirection:
              _sCtrl.jumpTo(
                0.0,
              );
              break;
            case DirectionOption.twoDirection:
              await _sCtrl.animateTo(
                0.0,
                duration: backDuration,
                curve: backwardAnimation,
              );
              break;
          }
        }
        repeated = autoRepeat;
      } else {
        await Future.delayed(pauseDuration);
      }
    } while (repeated);
  }

  @override
  Widget build(BuildContext context) {
    bool repeated = true;
    scroll(repeated);
    return Directionality(
      textDirection: textDirection,
      child: SingleChildScrollView(
        scrollDirection: direction,
        controller: _sCtrl,
        padding: EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
