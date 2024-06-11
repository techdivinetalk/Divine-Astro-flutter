import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadio<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  const CustomRadio(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChanged})
      : super(key: key);

  @override
  State<CustomRadio<T>> createState() => _CustomRadioState<T>();
}

class _CustomRadioState<T> extends State<CustomRadio<T>> {
  @override
  Widget build(BuildContext context) {
    bool selected = (widget.value == widget.groupValue);

    return InkWell(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: appColors.darkBlue)),
        child: Center(
          child: selected
              ? Container(
                  width: 16.w,
                  height: 16.h,
                  decoration:  BoxDecoration(
                      shape: BoxShape.circle, color: appColors.guideColor),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
