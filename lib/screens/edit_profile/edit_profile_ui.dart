import 'dart:developer';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_light_yellow_btn.dart';
import '../../../common/text_field_custom.dart';
import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/strings.dart';
import '../../../gen/assets.gen.dart';
import '../../common/common_bottomsheet.dart';
import 'edit_profile_controller.dart';

class EditProfileUI extends GetView<EditProfileController> {
  const EditProfileUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLightYellowButton(
            name: AppString.saveChanges,
            onTaped: () {},
          ),
        ],
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          AppString.editProfile,
          style: AppTextStyle.textStyle16(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.name,
                    style: AppTextStyle.textStyle14(),
                  ),
                  Assets.images.icEdit.svg(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.hintTextName,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text),
              SizedBox(
                height: 20.h,
              ),
              Text(
                AppString.speciality,
                style: AppTextStyle.textStyle14(),
              ),
              SizedBox(
                height: 5.h,
              ),
              Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3.0,
                            offset: const Offset(0.3, 3.0)),
                      ]),
                  child: Wrap(
                    children: [
                      ...List.generate(controller.tags.length + 1, (index) {
                        if (index == controller.tags.length) {
                          return InkWell(
                            onTap: () {
                              openBottomSheet(context, functionalityWidget:
                                  StatefulBuilder(builder: (context, setState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ChipsChoice<int>.multiple(
                                      spacing: 10,
                                      value: controller.tagIndexes,
                                      onChanged: (val) {
                                        controller.tagIndexes.clear();
                                        controller.tags.clear();
                                        debugPrint("$val");
                                        for (var element in val) {
                                          controller.tagIndexes.add(element);
                                          controller.tags
                                              .add(controller.options[element]);
                                        }
                                        setState(() {});
                                      },
                                      choiceItems:
                                          C2Choice.listFrom<int, String>(
                                        source: controller.options,
                                        value: (i, v) => i,
                                        label: (i, v) => v,
                                        tooltip: (i, v) => v,
                                        delete: (i, v) => () {
                                          controller.options.removeAt(i);
                                        },
                                      ),
                                      choiceStyle: C2ChipStyle.toned(
                                        iconSize: 0,
                                        backgroundColor: Colors.white,
                                        selectedStyle: C2ChipStyle.filled(
                                          selectedStyle: C2ChipStyle(
                                            foregroundStyle:
                                                AppTextStyle.textStyle16(
                                                    fontColor: AppColors.white),
                                            borderWidth: 1,
                                            backgroundColor: AppColors.darkBlue,
                                            borderStyle: BorderStyle.solid,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25)),
                                          ),
                                        ),
                                        borderWidth: 1,
                                        borderStyle: BorderStyle.solid,
                                        borderColor: AppColors.darkBlue,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      wrapped: true,
                                    ),
                                  ],
                                );
                              }));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.h, top: 4.h),
                              child: Container(
                                width: ScreenUtil().screenWidth / 2.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 1, color: AppColors.darkBlue)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 9.h, bottom: 9.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: AppColors.darkBlue,
                                        size: 19.sp,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Add Speciality",
                                        style: AppTextStyle.textStyle12(
                                            fontColor: AppColors.darkBlue,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 0.h),
                          child: Chip(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            label: Text(
                              controller.tags[index],
                              style: AppTextStyle.textStyle14(
                                  fontColor: AppColors.darkBlue),
                            ),
                            deleteIcon: Icon(
                              Icons.close,
                              size: 18.sp,
                            ),
                            onDeleted: () {
                              log("message");
                              controller.tags.removeAt(index);
                            },
                            backgroundColor: AppColors.lightYellow,
                            clipBehavior: Clip.antiAlias,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.experience,
                    style: AppTextStyle.textStyle14(),
                  ),
                  Assets.images.icEdit.svg(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              WhiteTextField(
                  hintText: AppString.hintExperience,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.text),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.descriptions,
                    style: AppTextStyle.textStyle14(),
                  ),
                  Assets.images.icEdit.svg(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
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
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: AppString.hintDescriptions,
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
                          color: AppColors.appYellowColour,
                          width: 1.0,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String label;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool selected;
  final Function(bool selected) onSelect;

  const CustomChip({
    Key? key,
    required this.label,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.selected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      duration: const Duration(milliseconds: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: selected
            ? (color ?? Colors.green)
            : theme.unselectedWidgetColor.withOpacity(.12),
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        border: Border.all(
          color: selected
              ? (color ?? Colors.green)
              : theme.colorScheme.onSurface.withOpacity(.38),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(selected ? 25 : 10)),
        onTap: () => onSelect(!selected),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // AnimatedCheckmark(
            //   active: selected,
            //   color: Colors.white,
            //   size: const Size.square(32),
            //   weight: 5,
            //   duration: const Duration(milliseconds: 400),
            // ),
            Positioned(
              left: 9,
              right: 9,
              bottom: 7,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  final String title;
  final Widget child;

  const Content({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3.0,
              offset: const Offset(0.0, 3.0)),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(fit: FlexFit.loose, child: widget.child),
        ],
      ),
    );
  }
}
