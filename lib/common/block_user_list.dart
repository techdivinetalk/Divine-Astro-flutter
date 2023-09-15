import 'dart:ui';

import 'package:divine_astrologer/common/cached_network_image.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/unblock_user.dart';
import 'package:divine_astrologer/screens/live_page/live_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'colors.dart';

class BlockUserList extends GetView<LiveController> {
  BlockUserList({Key? key,this.hostId}) : super(key: key);
  FirebaseDatabase database = FirebaseDatabase.instance;
  String? hostId;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(50.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    CustomText("Blocked User",
                        fontSize: 16.sp,
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.bold),
                    SizedBox(height: 20.h),
                    StreamBuilder<DatabaseEvent>(
                      stream: database.ref().child("live/$hostId/blockUser").onValue,
                      builder: (context, snapshot) {
                        if(snapshot.hasError){
                          return const SizedBox();
                        }else if(!snapshot.hasData){
                          return const SizedBox();
                        }else if(snapshot.data == null){
                          return const SizedBox();
                        }else if(snapshot.data!.snapshot.children.isNotEmpty){
                          return ListView.separated(
                            itemCount: snapshot.data!.snapshot.children.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            itemBuilder: (context, index) {
                              var item = snapshot.data!.snapshot.children.toList()[index];
                              var value = item.value as Map;
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: AppColors.appYellowColour),
                                    color: AppColors.white),
                                height: 50.h,
                                child: Row(
                                  children: [
                                    SizedBox(width: 20.w),
                                    SizedBox(
                                        width: 20.w,
                                        child: CustomText(
                                          (index + 1).toString(),
                                          fontColor: AppColors.darkBlue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        )),
                                    SizedBox(width: 8.w),
                                    Container(
                                      width: 32.w,
                                      height: 32.h,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.blackColor),
                                      child: CachedNetworkPhoto(
                                        url: "",
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    CustomText(value["name"],
                                        fontSize: 16.sp,
                                        fontColor: AppColors.darkBlue,
                                        fontWeight: FontWeight.w600),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return UnblockOrBlockUser(
                                                name: value["name"],
                                                isForBlocUser: false,
                                                blockUnblockTap: () {
                                                  Get.back();
                                                  controller.unblockUser(
                                                      customerId: value["id"],
                                                      name: value["name"]);
                                                },
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.more_vert))
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 20.h);
                            },
                          );
                        }
                        return const SizedBox();
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
