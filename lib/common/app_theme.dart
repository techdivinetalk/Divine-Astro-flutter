import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
/// This class contains all UI related styles
///
class AppTheme extends StatefulWidget {
  final Widget? child;

  const AppTheme({Key? key, @required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppThemeState();
  }

  static AppThemeState of(BuildContext context) {
    final _InheritedStateContainer? inheritedStateContainer =
    context.dependOnInheritedWidgetOfExactType();
    if (inheritedStateContainer == null) {
      return AppThemeState();
    } else {
      return inheritedStateContainer.data!;
    }
  }
}

class AppThemeState extends State<AppTheme> {
  double getFont(double value) => ScreenUtil().setSp(value);

  double getWidth(double value) => ScreenUtil().setWidth(value);

  double getHeight(double value) => ScreenUtil().setHeight(value);

  ///
  /// Define All your colors here which are used in whole application
  ///
  Color get whiteColor =>  appColors.white;

  Color get redColor => Colors.red;

  Color get background => const Color(0xFF293239);

  Color get buttonColor => const Color(0xFF00AB9D);

  Color get hintTextColor => const Color(0XFF00AB9D);

  Color get badgeColor => const Color(0xFFE51C66);

  Color get borderColor => const Color(0x80673AB7);

  Color get primaryColor => const Color(0xFF0256A6);

  Color get dividerColor => const Color(0xFFC2C2C2);

  Color get blackColor => const Color(0xFF000000);

  Color get shadowColor => const Color(0x1A2D1657);

  Color get shimmerBackgroundColor => const Color(0xff484848).withOpacity(0.3);

  Color get shimmerBaseColor => Colors.grey[300] ?? Colors.grey;

  Color get shimmerHighlightColor => Colors.grey[100] ?? Colors.grey;

  ///
  /// Mention height and width which are mentioned in your design file(i.e XD)
  /// to maintain ratio for all other devices
  ///
  double get expectedDeviceWidth => 900;

  double get expectedDeviceHeight => 1950;

  TextStyle customTextStyle(
      {double fontSize = 12, Color? color, TextDecoration? decoration}) {
    return TextStyle(
        decoration: decoration, fontSize: getFont(fontSize), color: color);
  }

  TextStyle textStyle(double fontSize, Color? color) {
    return TextStyle(fontSize: getFont(fontSize), color: color);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final AppThemeState? data;

  _InheritedStateContainer({
    Key? key,
    @required this.data,
    @required Widget? child,
  })  : assert(child != null),
        super(key: key, child: child!);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
