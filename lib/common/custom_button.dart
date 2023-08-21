import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final EdgeInsets? padding;
  final double? radius;
  final Color? color;
  final BoxBorder? border;

  const CustomButton(
      {super.key,
        required this.onTap,
        this.radius,
        required this.child,
        this.padding,
        this.color,
        this.border});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 5.sp),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          child: Ink(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: color ?? Colors.transparent,
              borderRadius: BorderRadius.circular(radius ?? 5.sp),
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}