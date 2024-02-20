import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/utils/utils.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> selectPlaceOfBirth(
    BuildContext context, void Function(City value) onSelect) async {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => SelectPlaceOfBirth(onSelect: onSelect),
  );
}

class SelectPlaceOfBirth extends StatelessWidget {
  const SelectPlaceOfBirth({Key? key, required this.onSelect})
      : super(key: key);

  final void Function(City value) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border.all(color: appColors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: appColors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: context.width,
            height: context.height / 2,
            decoration:  BoxDecoration(
              borderRadius:const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  child: Assets.images.createAccLocation.svg(
                    width: 66.w,
                    height: 50.h,
                  ),
                ),
                Material(
                  color: appColors.transparent,
                  child: Text(
                    "Select Place Of Birth".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: appColors.darkBlue,
                      fontSize: 20.0.sp,
                    ), 
                  ),
                ),
                SizedBox(height: 20.sp),
                Expanded(
                    child: AllCitiesList(
                  onSelect: onSelect,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AllCitiesList extends StatefulWidget {
  const AllCitiesList({Key? key, required this.onSelect}) : super(key: key);

  final void Function(City value) onSelect;

  @override
  State<AllCitiesList> createState() => _AllCitiesListState();
}

class _AllCitiesListState extends State<AllCitiesList> {
  late Future<List<City>> cities;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    ///"${Get.locale?.countryCode.toString()}"
    cities = getCountryCities("IN");
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  OutlineInputBorder get border => OutlineInputBorder(
        borderSide: BorderSide(
          color: appColors.darkBlue.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 15.w,
              right: 15.w,
              top: 5.h,
              bottom: 17.h,
            ),
            child: TextField(
              enabled: true,
              autofocus: true,
              controller: controller,
              onChanged: (value) => setState(() {}),
              cursorColor: appColors.darkBlue.withOpacity(0.2),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 10.w,
                  ),
                  child: Assets.images.createAccSearch.svg(),
                ),
                hintStyle: TextStyle(
                  color: appColors.darkBlue.withOpacity(0.2),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
                hintText: "searchPlaceBirth".tr,
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: cities,
              builder: (context, AsyncSnapshot<List<City>> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: snapshot.data!
                        .search(controller.text)
                        .map<Widget>(
                          (element) => Theme(
                            data: ThemeData(useMaterial3: false),
                            child: InkWell(
                              onTap: () => widget.onSelect(element),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 22.w,
                                ),
                                child: Text(
                                  element.name,
                                  style: TextStyle(
                                    fontFamily: FontFamily.poppins,
                                    fontWeight: FontWeight.w400,
                                    color: appColors.darkBlue,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.sp,
                    valueColor:  AlwaysStoppedAnimation(appColors.guideColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
