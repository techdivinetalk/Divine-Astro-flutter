import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/TextFieldCustom.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/strings.dart';
import 'BlockUserController.dart';

class BlockedUserUI extends GetView<BlockUserController> {
  const BlockedUserUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          AppString.blockedUsers,
          style: AppTextStyle.textStyle16(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(14.h),
        child: Column(
          children: [
            WhiteTextField(
                hintText: AppString.searchBlockUserHint,
                inputAction: TextInputAction.done,
                inputType: TextInputType.text,
                icon: const Icon(Icons.search)),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 45.h,
                              width: 45.h,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 15.h,
                            ),
                            Text(
                              "Deep Pratap",
                              style: AppTextStyle.textStyle16(),
                            ),
                            const Expanded(child: SizedBox()),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(width: 1)),
                                child: Text(
                                  AppString.unblock,
                                  style: AppTextStyle.textStyle12(),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
