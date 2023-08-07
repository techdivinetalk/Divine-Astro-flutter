import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import '../../screens/side_menu/side_menu_ui.dart';
import 'profile_controller.dart';

class ProfileUI extends GetView<ProfileController> {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      drawer: const SideMenuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Assets.images.bgTmpUser
                              .svg(height: 80.h, width: 80.w),
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lightGreen),
                            height: 13.h,
                            width: 13.h,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 5.h),
                          decoration: BoxDecoration(
                              color: AppColors.lightYellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.h))),
                          child: Text(
                            AppString.follow,
                            style: TextStyle(
                                color: AppColors.brownColour,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp),
                          ))
                    ],
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pushpak',
                              style: AppTextStyle.textStyle20(),
                            ),
                            Row(
                              children: [
                                Text(
                                  '4.5 ',
                                  style: AppTextStyle.textStyle14(
                                      fontWeight: FontWeight.w700),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 16.h,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Assets.images.icBook.svg(
                              height: 15.h,
                              width: 15.w,
                            ),
                            SizedBox(
                              width: 5.h,
                            ),
                            Expanded(
                              child: Text(
                                'Vedic, Numerology, Prashana',
                                style: AppTextStyle.textStyle12(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Assets.images.icLanguage.svg(
                              height: 13.h,
                              width: 13.w,
                            ),
                            SizedBox(
                              width: 5.h,
                            ),
                            Expanded(
                              child: Text(
                                'Hindi',
                                style: AppTextStyle.textStyle12(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Assets.images.icSuitcase.svg(
                              height: 13.h,
                              width: 13.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Exp: 10 ${AppString.years}',
                                  style: AppTextStyle.textStyle12(),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '₹25',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: AppColors.redColor),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Text(
                                      '₹5/Min',
                                      style: AppTextStyle.textStyle12(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: const Divider(),
              ),
              Container(
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.h))),
                child: ReadMoreText(
                  "I am a certified and professional Legal Astrologer with more than 10 years of experience. And I wouldhave felt happy to serve you through astrology.",
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: AppString.readMore,
                  trimExpandedText: AppString.showLess,
                  moreStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightYellow,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.lightYellow),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.h))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.ratings,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.h),
                                    child: Text(
                                      "4.5 ",
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 22.h,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: [
                                  Assets.images.icUser.svg(
                                      height: 20.h,
                                      width: 20.h,
                                      color: AppColors.appYellowColour),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "16045 ${AppString.total}",
                                    style: AppTextStyle.textStyle14(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //5
                            Row(
                              children: [
                                Assets.images.icFiveStar.svg(
                                  width: 80.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.6,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //4
                            Row(
                              children: [
                                Assets.images.icFourStar.svg(
                                  width: 70.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.2,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //3
                            Row(
                              children: [
                                Assets.images.icThreeStar.svg(
                                  width: 55.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.5,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //2
                            Row(
                              children: [
                                Assets.images.icTwoStar.svg(
                                  width: 35.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.8,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //1
                            Row(
                              children: [
                                Assets.images.icOneStar.svg(
                                  width: 15.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.5,
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      AppColors.lightYellow.withOpacity(0.4),
                                  progressColor: AppColors.lightYellow,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.userReview,
                      style: AppTextStyle.textStyle20(),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ListView.builder(
                      itemCount: 2,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Assets.images.bgUserProfile.svg(
                                  height: 45.h,
                                  width: 45.h,
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Rahul Shah",
                                            style: AppTextStyle.textStyle14(),
                                          ),
                                          Row(
                                            children: [
                                              RatingBar.readOnly(
                                                filledIcon: Icons.star,
                                                emptyIcon: Icons.star,
                                                emptyColor: AppColors
                                                    .appYellowColour
                                                    .withOpacity(0.3),
                                                filledColor:
                                                    AppColors.appYellowColour,
                                                initialRating: 4,
                                                size: 15.h,
                                                maxRating: 5,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              PopupMenuButton(
                                                surfaceTintColor:
                                                    Colors.transparent,
                                                color: Colors.white,
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppString.reportComment,
                                                      style: AppTextStyle
                                                          .textStyle13(),
                                                    ),
                                                  )),
                                                ],
                                                child: const Icon(
                                                    Icons.more_vert_rounded),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Text(
                                        "12 Feb 2021, 03:00 PM",
                                        style: AppTextStyle.textStyle12(),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "It was really nice, talking to Pushpak sir it made me more confident.",
                                        style: AppTextStyle.textStyle12(),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      // TextFieldCustom(
                                      //     "Reply here...",
                                      //     TextInputType.text,
                                      //     TextInputAction.done),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 40.h,
                                            width: 40.h,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 10.h,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Pushpak",
                                                  style:
                                                      AppTextStyle.textStyle14(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                Text(
                                                  "12 Feb 2021, 03:10 PM",
                                                  style: AppTextStyle
                                                      .textStyle12(),
                                                ),
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Text(
                                                  "It was really nice, talking to Pushpak sir it made me more confident.",
                                                  style: AppTextStyle
                                                      .textStyle12(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.sp),
                              child: const Divider(),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  commonAppBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: Text(
        AppString.profile,
        style: AppTextStyle.textStyle16(),
      ),
      actions: [
        Padding(
            padding: EdgeInsets.all(11.h),
            child: PopupMenuButton(
              surfaceTintColor: Colors.transparent,
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RouteName.editProfileUI);
                  },
                  child: Row(
                    children: [
                      Assets.images.icEdit.svg(height: 18.h, width: 18.w),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        AppString.editProfile,
                        style: AppTextStyle.textStyle13(),
                      )
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RouteName.orderHistory);
                  },
                  child: Row(
                    children: [
                      Assets.images.icOrderHistory
                          .svg(height: 18.h, width: 18.w),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        AppString.orderHistory,
                        style: AppTextStyle.textStyle13(),
                      )
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RouteName.bankDetailsUI);
                  },
                  child: Row(
                    children: [
                      Assets.images.icBankDetail.svg(height: 18.h, width: 18.w),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        AppString.bankDetails,
                        style: AppTextStyle.textStyle13(),
                      )
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RouteName.priceHistoryUI);
                  },
                  child: Row(
                    children: [
                      Assets.images.icPrice.svg(height: 18.h, width: 18.w),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        AppString.priceChangeRequest,
                        style: AppTextStyle.textStyle13(),
                      )
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RouteName.numberChangeReqUI);
                  },
                  child: Row(
                    children: [
                      Assets.images.icCalling.svg(height: 18.h, width: 18.w),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        AppString.numberChangeRequest,
                        style: AppTextStyle.textStyle13(),
                      )
                    ],
                  ),
                )),
                PopupMenuItem(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(RouteName.blockedUser);
                  },
                  child: Row(
                    children: [
                      Assets.images.icBlock.svg(height: 18.h, width: 18.w),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text(
                        AppString.blockedUsers,
                        style: AppTextStyle.textStyle13(),
                      )
                    ],
                  ),
                )),
              ],
              child: const Icon(Icons.more_vert_rounded),
            )),
      ],
    );
  }
}
