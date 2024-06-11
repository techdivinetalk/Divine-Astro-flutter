import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import 'colors.dart';

class UnblockOrBlockUser extends StatelessWidget {
  final String? name;
  final bool isForBlocUser;
  final VoidCallback? blockUnblockTap;

  const UnblockOrBlockUser(
      {Key? key, this.name, required this.isForBlocUser, this.blockUnblockTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
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
                border: Border.all(color: appColors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: appColors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          AlertDialog(
            backgroundColor: appColors.white,
            surfaceTintColor: appColors.white,
            shape: OutlineInputBorder(
              borderSide:  BorderSide(color: appColors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    blockUnblockTap!.call();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.svg.block.svg(),
                      SizedBox(width: 16.w),
                      Text(
                        "${isForBlocUser ? "Block" : "Unblock"} $name?",
                        style: TextStyle(
                            fontSize: 16.sp, color: appColors.darkBlue),
                      )
                    ],
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
