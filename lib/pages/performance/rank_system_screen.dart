import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../gen/assets.gen.dart';

class RankSystemScreen extends StatefulWidget {
  const RankSystemScreen({super.key});

  @override
  State<RankSystemScreen> createState() => _RankSystemScreenState();
}

class _RankSystemScreenState extends State<RankSystemScreen> {
  List rankList = [
    {
      "total_marks": "90%+",
      "rankSvg": "assets/svg/diamond.svg",
      "rank": "Diamond",
    },
    {
      "total_marks": "89-80%",
      "rankSvg": "assets/svg/platinum.svg",
      "rank": "Platinum",
    },
    {
      "total_marks": "79-70%",
      "rankSvg": "assets/svg/gold.svg",
      "rank": "Gold",
    },
    {
      "total_marks": "69-60%",
      "rankSvg": "assets/svg/silver.svg",
      "rank": "Silver",
    },
    {
      "total_marks": "59-36%",
      "rankSvg": "assets/svg/bronze.svg",
      "rank": "Bronze",
    },
    {
      "total_marks": "Less than 35%",
      "rankSvg": "",
      "rank": "Unranked",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 25.sp,
            color: appColors.textColor,
          ),
        ),
        title: Text(
          "Rank System",
          style: AppTextStyle.textStyle16(
            fontColor: appColors.textColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: appColors.textColor.withOpacity(0.15),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                )
              ],
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Total Marks Obtained",
                            style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w700,
                              fontColor: appColors.textColor,
                            ),
                          ),
                          Text(
                            "(in % Percentage)",
                            style: AppTextStyle.textStyle14(
                              fontWeight: FontWeight.w400,
                              fontColor: appColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Astrologer\nRank",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w700,
                          fontColor: appColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ...List.generate(
                  rankList.length,
                  (index) => RowWidget(
                    title: rankList[index]["total_marks"],
                    rank: rankList[index]["rank"],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Note : The data will undergo regular refresh cycles with a frequency of once every 10 days.",
            style: AppTextStyle.textStyle14(
              fontColor: appColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget RowWidget({String? title, rank}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? "",
              textAlign: TextAlign.center,
              style: AppTextStyle.textStyle14(
                fontColor: appColors.textColor,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                setImage(rank),
                const SizedBox(width: 5),
                Text(rank,
                    style: AppTextStyle.textStyle14(
                      fontColor: appColors.textColor,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  setImage(String rank) {
    if (rank == "Diamond") {
      return Assets.images.icDiamond.image(height: 21.h, width: 21.h);
    } else if (rank == "Platinum") {
      return Assets.images.icPlatinum.image(height: 21.h, width: 21.h);
    } else if (rank == "Gold") {
      return Assets.images.icGold.image(height: 21.h, width: 21.h);
    } else if (rank == "Silver") {
      return Assets.images.icSilver.image(height: 21.h, width: 21.h);
    } else if (rank == "Bronze") {
      return Assets.images.icBronze.image(height: 21.h, width: 21.h);
    } else {
      return SizedBox(
        width: 10.w,
      );
    }
  }
}
