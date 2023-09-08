import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/app_textstyle.dart';
import '../../../../common/colors.dart';
import '../kundli_detail_controller.dart';

class DashaUI extends StatefulWidget {
  const DashaUI({super.key});

  @override
  State<DashaUI> createState() => _DashaUIState();
}

class _DashaUIState extends State<DashaUI> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliDetailController>(builder: (controller) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 40.h),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.isVimshottari.value = true;
                            controller.isYogini.value = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.isVimshottari.value
                                      ? Colors.white
                                      : AppColors.blackColor),
                              borderRadius: BorderRadius.circular(20),
                              color: controller.isVimshottari.value
                                  ? AppColors.lightYellow
                                  : Colors.white),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 12.h),
                            child: Text(
                              "vimshottari".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.isVimshottari.value = false;
                            controller.isYogini.value = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: controller.isYogini.value
                                      ? Colors.white
                                      : AppColors.blackColor),
                              color: controller.isYogini.value
                                  ? AppColors.lightYellow
                                  : AppColors.white),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 12.h),
                            child: Text(
                              "yogini".tr,
                              style: AppTextStyle.textStyle14(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: controller.isVimshottari.value == true
                          ? controller.isSubDasha.value
                              ? const VimshottariSubWidget()
                              : const vimshottariWidget()
                          : const yoginiWidget(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

// ignore: camel_case_types
class vimshottariWidget extends GetView<KundliDetailController> {
  const vimshottariWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("mahadasha".tr,
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
        SizedBox(
          height: 15.h,
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Planet",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.planetList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.planetList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                model.first,
                                style: AppTextStyle.textStyle12(
                                    fontColor: Colors.black),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              verticalDivider(),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Start\nDate",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.startDateList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.startDateList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                model.first,
                                style: AppTextStyle.textStyle12(
                                    fontColor: Colors.black),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              verticalDivider(),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "End\nDate",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.endDateList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.endDateList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.isSubDasha.value = true;
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      model.first,
                                      style: AppTextStyle.textStyle12(
                                          fontColor: Colors.black),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      size: 12,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          "mahadashNote".tr,
          style: AppTextStyle.textStyle16(fontColor: AppColors.appYellowColour),
        )
      ],
    );
  }

  Widget verticalDivider() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 30),
      width: 0.9,
      height: controller.planetList.length * 45 + 45,
      color: AppColors.lightGrey,
    );
  }
}

// ignore: camel_case_types
class yoginiWidget extends GetView<KundliDetailController> {
  const yoginiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("bhadrika".tr,
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
        SizedBox(
          height: 15.h,
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Planet",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.planetList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.planetList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                  child: Text(
                                model.first,
                                style: AppTextStyle.textStyle10(
                                    fontColor: Colors.black),
                              )),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 0.9,
                height: controller.planetList.length * 40 + 45,
                color: AppColors.lightGrey,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Start\nDate",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.startDateList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.startDateList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                  child: Text(
                                model.first,
                                style: AppTextStyle.textStyle10(
                                    fontColor: Colors.black),
                              )),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 0.9,
                height: controller.planetList.length * 40 + 45,
                color: AppColors.lightGrey,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "End\nDate",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.endDateList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.endDateList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                  child: Text(
                                model.first,
                                style: AppTextStyle.textStyle10(
                                    fontColor: Colors.black),
                              )),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text("rashiChart".tr,
            style: AppTextStyle.textStyle16(
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
      ],
    );
  }
}

class VimshottariSubWidget extends GetView<KundliDetailController> {
  const VimshottariSubWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.isSubDasha.value = false;
              },
              child: Text("mahadasha".tr,
                  style: AppTextStyle.textStyle16(
                      fontWeight: FontWeight.w500,
                      fontColor: AppColors.appYellowColour)),
            ),
            const Icon(Icons.chevron_right),
            Text("antarDasha".tr,
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500,
                    fontColor: AppColors.appYellowColour)),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Planet",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.planetList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.planetList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                  child: Text(
                                model.first,
                                style: AppTextStyle.textStyle10(
                                    fontColor: Colors.black),
                              )),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 0.9,
                height: controller.planetList.length * 40 + 45,
                color: AppColors.lightGrey,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Start\nDate",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.startDateList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.startDateList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                  child: Text(
                                model.first,
                                style: AppTextStyle.textStyle10(
                                    fontColor: Colors.black),
                              )),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 0.9,
                height: controller.planetList.length * 40 + 45,
                color: AppColors.lightGrey,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 65.h,
                      width: 76.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "End\nDate",
                          style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.brownColour),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeLeft: true,
                      removeRight: true,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.endDateList.length,
                        // : true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var model = controller.endDateList[index];
                          return Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                  child: Text(
                                model.first,
                                style: AppTextStyle.textStyle10(
                                    fontColor: Colors.black),
                              )),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColors.lightYellow, borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Text(
                "levelUp".tr,
                style: AppTextStyle.textStyle20(
                    fontWeight: FontWeight.w600, fontColor: AppColors.brownColour),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Text(
          "mahadashNote".tr,
          style: AppTextStyle.textStyle16(fontColor: AppColors.appYellowColour),
        )
      ],
    );
  }
}
