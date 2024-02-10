import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveStar extends StatelessWidget {
  final String? name, url;

  const LiveStar({Key? key, this.name, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250.h,
        child: Stack(
          children: [
            AlertDialog(
              backgroundColor: appColors.white,
              surfaceTintColor: appColors.white,
              shape: OutlineInputBorder(
                borderSide:  BorderSide(color: appColors.appYellowColour),
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  SizedBox(
                    width: 110.w,
                    height: 88.h,
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            width: 80.w,
                            height: 80.h,
                          ),
                        ),
                        Positioned(
                            bottom: 0.h,
                            right: 0.h,
                            child: Center(
                              child: Assets.images.championLive
                                  .image(width: 56.w, height: 56.h),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: <InlineSpan>[
                        TextSpan(
                            text: "Raj ",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: appColors.darkBlue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "is your",
                            style: TextStyle(
                                fontSize: 16.sp, color: appColors.darkBlue))
                      ])),
                      Text.rich(TextSpan(children: <InlineSpan>[
                        TextSpan(
                            text: "Live Star ",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: appColors.appYellowColour,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "now!!!",
                            style: TextStyle(
                                fontSize: 16.sp, color: appColors.darkBlue))
                      ])),
                      Text("Okay! Got it.",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: appColors.darkBlue,
                              decoration: TextDecoration.underline)),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 30.h,
                child: Assets.images.planetStarLive
                    .image(width: 132.w, height: 132.h)),
            Positioned(
                bottom: 20,
                right: 40.h,
                child:
                    Assets.images.starLiveBig.image(width: 80.w, height: 80.h))
          ],
        ),
      ),
    );
  }
}
