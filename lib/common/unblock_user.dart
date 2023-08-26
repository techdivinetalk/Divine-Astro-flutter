import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import 'cached_network_image.dart';
import 'colors.dart';

class UnblockOrBlockUser extends StatelessWidget {
  final String? name;
  final bool isForBlocUser;
  const UnblockOrBlockUser({Key? key,this.name,required this.isForBlocUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: AppColors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          AlertDialog(
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            shape: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.svg.block.svg(),
                    SizedBox(width: 16.w),
                    Text("${isForBlocUser ? "Block" : "Unblock"} $name?",style: TextStyle(fontSize: 16.sp,color: AppColors.textColor),)
                  ],
                ),
                SizedBox(height: 20.h),
                Center(child: Divider(color: AppColors.textColor.withOpacity(.2))),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.svg.reply.svg(),
                    SizedBox(width: 16.w),
                    Text("Reply",style: TextStyle(fontSize: 16.sp,color: AppColors.textColor),)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}