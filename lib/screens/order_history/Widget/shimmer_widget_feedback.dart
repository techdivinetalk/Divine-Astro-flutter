import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.h,
                      height: 12.h,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 100.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                  ],
                ),
                Container(
                  width: 100.w,
                  height: 12.h,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 100.h),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 100.w,
                  height: 12.h,
                  color: Colors.white,
                ),
                const Spacer(),
                Container(
                  width: 40.w,
                  height: 40.h,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

