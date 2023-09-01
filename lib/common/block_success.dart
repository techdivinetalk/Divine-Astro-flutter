import 'package:divine_astrologer/common/cached_network_image.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BlockSuccess extends StatelessWidget {
  final String? url,text;

  const BlockSuccess({Key? key, this.url,this.text}) : super(key: key);

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
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkPhoto(
                    width: 32.w,
                    height: 32.h,
                    url: url ?? "",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    text ?? "",
                    maxLines: 2,
                    style: TextStyle(fontSize: 16.sp, color: AppColors.textColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
