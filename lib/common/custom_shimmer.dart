import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'colors.dart';

class CustomShimmer{
 static Widget shimmerTile( {double? height, double? width,double? borderRadius}){
    return VxShimmer(
      child: Container(
        padding: EdgeInsets.all(2.w),
        height: height?? 20.h,
        width: width?? 100.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius?? 10.w),
            color: AppColors.grey.withOpacity(0.25)
        ),
      
      ),
    );
  }
}