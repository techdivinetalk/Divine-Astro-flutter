import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';

class MoonChartUi extends StatelessWidget {
  const MoonChartUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight.h * 2.5),
          SizedBox(height: 25.h),
          Container(
            child: Assets.images.icKundliChart
                .image(width: ScreenUtil().screenWidth * 0.9),
          ),
        ],
      ),
    );
  }
}
