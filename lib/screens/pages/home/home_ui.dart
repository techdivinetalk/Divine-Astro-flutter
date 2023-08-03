import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';

class HomeUI extends GetView<SplashController> {
  const HomeUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 210.h,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 3.0)),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.darkYellow, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Training Videos",
                      style:
                          AppTextStyle.textStyle16(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int i) {
                          return Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.greyColor,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 150.h,
                                width: 110.h,
                              ),
                              SizedBox(
                                width: 10.w,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3.0,
                          offset: const Offset(0.3, 3.0)),
                    ]),
                child: Padding(
                  padding: EdgeInsets.all(10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.images.icCart.svg(),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "E-commerce",
                        style: AppTextStyle.textStyle20(
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.darkBlue),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffEDEDED)),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Any Feedbacks?",
                        style: AppTextStyle.textStyle16(
                            fontColor: AppColors.darkBlue),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "You are free to share your thoughts in order to help us improve.",
                        style: AppTextStyle.textStyle14(fontColor: AppColors.darkBlue),

                      ),
                      SizedBox(height: 10.h,),
                      Container(

                        height: 70.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3.0,
                                  offset: const Offset(0.3, 3.0)),
                            ]),
                        child: TextFormField(
                          maxLines: 3,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: "Type your feedback here! ",
                            helperStyle: AppTextStyle.textStyle16(),
                            fillColor: Colors.white,
                            hoverColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: AppColors.darkYellow,
                                  width: 1.0,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            decoration: BoxDecoration(
                                color: AppColors.lightYellow,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15.h),
                                  child: Text(
                                    "Submit Feedback",

                                    style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w600, fontColor: AppColors.darkCoffee),
                                  ),
                                ))),
                      ),
                      SizedBox(height: 20.h,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
