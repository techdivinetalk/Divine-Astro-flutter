import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import '../screens/live_page/live_controller.dart';
import 'colors.dart';
import 'custom_widgets.dart';

class WaitList extends StatelessWidget {
  final Function(String id, String name)? onAccept;
  FirebaseDatabase database = FirebaseDatabase.instance;
  String? astroId;
  final controller = Get.find<LiveController>();
  bool? showNext = false;
  Iterable<DataSnapshot> data = Iterable.empty();

  WaitList(
      {Key? key,
      this.onAccept,
      this.astroId,
      this.showNext,
      required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              //Get.back();
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
          const SizedBox(height: 10),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50.0)),
                color: AppColors.white,
                border: Border.all(color: AppColors.appYellowColour)),
            child: Column(
              children: [
                buildWaitList(),
                /*FutureBuilder<DataSnapshot>(
                    future: database.ref().child("live/$astroId/waitList").get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const SizedBox();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData) {
                        return const SizedBox();
                      } else if (snapshot.data == null) {
                        return const SizedBox();
                      } else if (snapshot.data!.children.isNotEmpty) {
                        if(showNext!){
                          if (snapshot.data!.children.length - 1 == 0) {
                            return buildWaitList();
                          }
                        }
                        return Column(
                          children: [
                            SizedBox(height: 32.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 21.w),
                                child: CustomText("Waitlist",
                                    fontSize: 20.sp,
                                    fontColor: AppColors.darkBlue),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            SizedBox(
                              height: 100.h,
                              child: ListView.separated(
                                itemCount:
                                    snapshot.data!.children.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  var item = snapshot.data!.children
                                      .toList()[index];
                                  var data = item.value as Map;
                                  return Container(
                                    decoration: const BoxDecoration(
                                        color: AppColors.white),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 32.w),
                                        Container(
                                          width: 34.w,
                                          height: 34.h,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: Assets.images.avatar.svg(),
                                        ),
                                        SizedBox(width: 10.w),
                                        CustomText(data["name"],
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w500,
                                            fontColor: AppColors.darkBlue),
                                        const Spacer(),
                                        const Icon(Icons.call,
                                            color: AppColors.darkBlue,
                                            size: 16),
                                        SizedBox(width: 10.w),
                                        CustomText("09 M 38 S",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontColor: AppColors.darkBlue),
                                        SizedBox(width: 32.w),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 20.h);
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    }),*/
                SizedBox(height: 20.h),
                showNext!
                    ? /*FutureBuilder<DataSnapshot>(
                    future:
                        database.ref().child("live/$astroId/waitList").get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const SizedBox();
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData) {
                        return const SizedBox();
                      } else if (snapshot.data == null) {
                        return const SizedBox();
                      } else if (snapshot.data!.children.isNotEmpty) {
                        var item = snapshot.data!.children.toList().first;
                        var data = item.value as Map;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 32.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 21.w),
                                child: CustomText("Next In Line",
                                    fontSize: 20.sp,
                                    fontColor: AppColors.darkBlue),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              decoration:
                                  const BoxDecoration(color: AppColors.white),
                              child: Row(
                                children: [
                                  SizedBox(width: 32.w),
                                  Container(
                                    width: 34.w,
                                    height: 34.h,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: Assets.images.avatar.svg(),
                                  ),
                                  SizedBox(width: 10.w),
                                  CustomText(
                                      data["name"] ?? "",
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      fontColor: AppColors.darkBlue),
                                  const Spacer(),
                                  const Icon(Icons.call,
                                      color: AppColors.darkBlue, size: 16),
                                  SizedBox(width: 10.w),
                                  CustomText("09 M 38 S",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      fontColor: AppColors.darkBlue),
                                  SizedBox(width: 32.w),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              width: Get.width,
                              height: 56.h,
                              child: CustomButton(
                                  onTap: () {
                                    onAccept!(data["id"],data["name"]);
                                  },
                                  color: AppColors.appYellowColour,
                                  radius: 28,
                                  child: Center(
                                    child: CustomText("Accept",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontColor: AppColors.brownColour),
                                  )),
                            ),
                          ],
                        );
                      }
                      return buildWaitList();
                    })*/
                    nextInLine()
                    : buildWaitList(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWaitList() {
    if (showNext!) {
      if (data.length - 1 == 0) {
        return SizedBox();
      }
    }
    return Column(
      children: [
        SizedBox(height: 32.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 21.w),
            child: CustomText("Waitlist",
                fontSize: 20.sp, fontColor: AppColors.darkBlue),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            itemCount: data.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              var item = data.toList()[index];
              var value = item.value as Map;
              return Container(
                decoration: const BoxDecoration(color: AppColors.white),
                child: Row(
                  children: [
                    SizedBox(width: 32.w),
                    Container(
                      width: 34.w,
                      height: 34.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Assets.images.avatar.svg(),
                    ),
                    SizedBox(width: 10.w),
                    CustomText(value["name"],
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        fontColor: AppColors.darkBlue),
                    const Spacer(),
                    const Icon(Icons.call, color: AppColors.darkBlue, size: 16),
                    SizedBox(width: 10.w),
                    CustomText(intToTimeLeft(value["duration"]),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.darkBlue),
                    SizedBox(width: 32.w),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 20.h);
            },
          ),
        ),
      ],
    );
  }

  Widget nextInLine() {
    var item = data.toList().first;
    var value = item.value as Map;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 32.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 21.w),
            child: CustomText("Next In Line",
                fontSize: 20.sp, fontColor: AppColors.darkBlue),
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          decoration: const BoxDecoration(color: AppColors.white),
          child: Row(
            children: [
              SizedBox(width: 32.w),
              Container(
                width: 34.w,
                height: 34.h,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Assets.images.avatar.svg(),
              ),
              SizedBox(width: 10.w),
              CustomText(value["name"] ?? "",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.darkBlue),
              const Spacer(),
              const Icon(Icons.call, color: AppColors.darkBlue, size: 16),
              SizedBox(width: 10.w),
              CustomText(intToTimeLeft(value["duration"]),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontColor: AppColors.darkBlue),
              SizedBox(width: 32.w),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          width: Get.width,
          height: 56.h,
          child: CustomButton(
              onTap: () {
                onAccept!(value["id"], value["name"]);
              },
              color: AppColors.appYellowColour,
              radius: 28,
              child: Center(
                child: CustomText("Accept",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontColor: AppColors.brownColour),
              )),
        ),
      ],
    );
  }
}

String intToTimeLeft(int value) {
  int h, m, s;

  h = value ~/ 3600;

  m = ((value - h * 3600)) ~/ 60;

  s = value - (h * 3600) - (m * 60);

  String result = "$h:$m:$s";
  if (h == 00) {
    result = "$m m $s s";
  } else {
    result = "$h h $m m $s s";
  }
  return result;
}
/*
Container(
clipBehavior: Clip.antiAlias,
decoration: BoxDecoration(
borderRadius:
const BorderRadius.vertical(top: Radius.circular(50.0)),
color: AppColors.white,
border: Border.all(color: AppColors.appYellowColour)),
child: Column(
children: [
FutureBuilder<DataSnapshot>(
future: database.ref().child("live/$astroId/waitList").get(),
builder: (context, snapshot) {
if (snapshot.hasError) {
return const SizedBox();
} else if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
} else if (!snapshot.hasData) {
return const SizedBox();
} else if (snapshot.data == null) {
return const SizedBox();
} else if (snapshot.data!.children.isNotEmpty) {
if(showNext!){
if (snapshot.data!.children.length - 1 == 0) {
return SizedBox();
}
}
return Column(
children: [
SizedBox(height: 32.h),
Align(
alignment: Alignment.centerLeft,
child: Padding(
padding: EdgeInsets.only(left: 21.w),
child: CustomText("Waitlist",
fontSize: 20.sp,
fontColor: AppColors.darkBlue),
),
),
SizedBox(height: 20.h),
SizedBox(
height: 100.h,
child: ListView.separated(
itemCount:
snapshot.data!.children.length,
shrinkWrap: true,
padding: EdgeInsets.zero,
itemBuilder: (context, index) {
var item = snapshot.data!.children
    .toList()[index];
var data = item.value as Map;
return Container(
decoration: const BoxDecoration(
color: AppColors.white),
child: Row(
children: [
SizedBox(width: 32.w),
Container(
width: 34.w,
height: 34.h,
clipBehavior: Clip.antiAlias,
decoration: const BoxDecoration(
shape: BoxShape.circle),
child: Assets.images.avatar.svg(),
),
SizedBox(width: 10.w),
CustomText(data["name"],
fontSize: 20.sp,
fontWeight: FontWeight.w500,
fontColor: AppColors.darkBlue),
const Spacer(),
const Icon(Icons.call,
color: AppColors.darkBlue,
size: 16),
SizedBox(width: 10.w),
CustomText("09 M 38 S",
fontSize: 16.sp,
fontWeight: FontWeight.w600,
fontColor: AppColors.darkBlue),
SizedBox(width: 32.w),
],
),
);
},
separatorBuilder: (context, index) {
return SizedBox(height: 20.h);
},
),
),
],
);
}
return const SizedBox();
}),
SizedBox(height: 20.h),
showNext! ? FutureBuilder<DataSnapshot>(
future:
database.ref().child("live/$astroId/waitList").get(),
builder: (context, snapshot) {
if (snapshot.hasError) {
return const SizedBox();
} else if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
} else if (!snapshot.hasData) {
return const SizedBox();
} else if (snapshot.data == null) {
return const SizedBox();
} else if (snapshot.data!.children.isNotEmpty) {
var item = snapshot.data!.children.toList().first;
var data = item.value as Map;
return Column(
mainAxisSize: MainAxisSize.min,
children: [
SizedBox(height: 32.h),
Align(
alignment: Alignment.centerLeft,
child: Padding(
padding: EdgeInsets.only(left: 21.w),
child: CustomText("Next In Line",
fontSize: 20.sp,
fontColor: AppColors.darkBlue),
),
),
SizedBox(height: 20.h),
Container(
decoration:
const BoxDecoration(color: AppColors.white),
child: Row(
children: [
SizedBox(width: 32.w),
Container(
width: 34.w,
height: 34.h,
clipBehavior: Clip.antiAlias,
decoration: const BoxDecoration(
shape: BoxShape.circle),
child: Assets.images.avatar.svg(),
),
SizedBox(width: 10.w),
CustomText(
data["name"] ?? "",
fontSize: 20.sp,
fontWeight: FontWeight.w500,
fontColor: AppColors.darkBlue),
const Spacer(),
const Icon(Icons.call,
color: AppColors.darkBlue, size: 16),
SizedBox(width: 10.w),
CustomText("09 M 38 S",
fontSize: 16.sp,
fontWeight: FontWeight.w600,
fontColor: AppColors.darkBlue),
SizedBox(width: 32.w),
],
),
),
SizedBox(height: 20.h),
Container(
margin: EdgeInsets.symmetric(horizontal: 20.w),
width: Get.width,
height: 56.h,
child: CustomButton(
onTap: () {
onAccept!(data["id"],data["name"]);
},
color: AppColors.appYellowColour,
radius: 28,
child: Center(
child: CustomText("Accept",
fontSize: 16.sp,
fontWeight: FontWeight.bold,
fontColor: AppColors.brownColour),
)),
),
],
);
}
return SizedBox();
}) : SizedBox(),
SizedBox(height: 20.h),
],
),
),*/
