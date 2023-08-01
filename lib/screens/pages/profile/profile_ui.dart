import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';

import 'profile_controller.dart';

class ProfileUI extends GetView<ProfileController> {
  const ProfileUI({Key? key}) : super(key: key);

  PopupMenuItem _buildPopupMenuItem(String menuTitle, IconData iconData) {
    return PopupMenuItem(
        height: 50,
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.black,
            ),
            Text(menuTitle)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Image.asset(
                            "assets/images/bg_tmpUser.png",
                            height: 80.h,
                            width: 80.w,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff27C884)),
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
                              color: const Color(0xffFDD48E),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.h))),
                          child: Text(
                            "Follow",
                            style: TextStyle(
                                color: const Color(0xff5F3C08),
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
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  '4.5 ',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
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
                            Image.asset(
                              "assets/images/ic_bookAlt.png",
                              height: 15.h,
                              width: 15.w,
                            ),
                            SizedBox(
                              width: 5.h,
                            ),
                            Expanded(
                              child: Text(
                                'Vedic, Numerology, Prashana',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/ic_language.png",
                              height: 15.h,
                              width: 15.w,
                            ),
                            SizedBox(
                              width: 5.h,
                            ),
                            Expanded(
                              child: Text(
                                'Hindi',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
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
                            Image.asset(
                              "assets/images/ic_suitcase.png",
                              height: 15.h,
                              width: 15.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Exp: 10 Years',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
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
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.red),
                                    ),
                                    SizedBox(
                                      width: 5.h,
                                    ),
                                    Text(
                                      '₹5/Min',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
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
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read more',
                  trimExpandedText: 'Show less',
                  moreStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffFDD48E),
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xffFDD48E)),
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
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.h))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ratings",
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
                                  Text(
                                    "4.5 ",
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w400),
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
                                  Image.asset(
                                    "assets/images/ic_user.png",
                                    height: 20.h,
                                    width: 20.h,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    "16045 total ",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
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
                                Image.asset(
                                  "assets/images/ic_fiveStar.png",
                                  width: 80.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.6,
                                  // center: Text("90.0%"),
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      const Color(0xffFDD48E).withOpacity(0.4),
                                  progressColor: const Color(0xffFDD48E),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //4
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/ic_fourStar.png",
                                  width: 70.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.2,
                                  // center: Text("90.0%"),
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      const Color(0xffFDD48E).withOpacity(0.4),
                                  progressColor: const Color(0xffFDD48E),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //3
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/ic_threeStar.png",
                                  width: 55.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.5,
                                  // center: Text("90.0%"),
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      const Color(0xffFDD48E).withOpacity(0.4),
                                  progressColor: const Color(0xffFDD48E),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //2
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/ic_twoStar.png",
                                  width: 35.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.8,
                                  // center: Text("90.0%"),
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      const Color(0xffFDD48E).withOpacity(0.4),
                                  progressColor: const Color(0xffFDD48E),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            //1
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/ic_oneStar.png",
                                  width: 15.w,
                                ),
                                LinearPercentIndicator(
                                  width: 100.w,
                                  barRadius: const Radius.circular(10),
                                  animation: true,
                                  lineHeight: 10.0,
                                  animationDuration: 2000,
                                  percent: 0.5,
                                  // center: Text("90.0%"),
                                  // ignore: deprecated_member_use
                                  linearStrokeCap: LinearStrokeCap.round,
                                  backgroundColor:
                                      const Color(0xffFDD48E).withOpacity(0.4),
                                  progressColor: const Color(0xffFDD48E),
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
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0)),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Review",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/bg_userProfile.png",
                          height: 45.h,
                          width: 45.h,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rahul Shah",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    children: [
                                      RatingBar.readOnly(
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star,
                                        emptyColor: const Color(0xffFCB742)
                                            .withOpacity(0.3),
                                        filledColor: const Color(0xffFCB742),
                                        initialRating: 4,
                                        size: 15.h,
                                        maxRating: 5,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        "assets/images/ic_menuButton.png",
                                        height: 14.h,
                                        width: 14.h,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                "12 Feb 2021, 03:00 PM",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "It was really nice, talking to Pushpak sir it made me more confident.",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "12 Feb 2021, 03:10 PM",
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Text(
                                          "It was really nice, talking to Pushpak sir it made me more confident.",
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500),
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
