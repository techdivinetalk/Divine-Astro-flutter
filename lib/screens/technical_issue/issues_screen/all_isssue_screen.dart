import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../common/app_textstyle.dart';
import '../../../repository/user_repository.dart';
import '../issue_controller.dart';

class AllTechnicalIssueScreen extends GetView<TechnicalIssueController> {
  AllTechnicalIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TechnicalIssueController>(
      init: TechnicalIssueController(UserRepository()),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors().white,
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: IconButton(
                visualDensity: const VisualDensity(horizontal: -4),
                constraints: BoxConstraints.loose(Size.zero),
                icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 14),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            titleSpacing: 0,
            title: Text(
              "All Issues",
              style: AppTextStyle.textStyle16(),
            ),
            // centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                children: [],
              ),
            ),
          ),
        );
      },
    );
  }
}
