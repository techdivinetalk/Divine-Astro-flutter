import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/utils.dart';
import 'package:divine_astrologer/utils/custom_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/colors.dart';
import '../../../../gen/assets.gen.dart';

Future<void> countryPickerSheet(
    BuildContext context, void Function(Country value) onSelect) async {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => CountryPickerSheetWidget(onSelect: onSelect),
  );
}

class CountryPickerSheetWidget extends StatelessWidget {
  const CountryPickerSheetWidget({Key? key, required this.onSelect})
      : super(key: key);

  final void Function(Country value) onSelect;

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
            width: context.width,
            height: context.height / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
              color: AppColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  child: Assets.images.icLocation.svg(
                    width: 66.w,
                    height: 50.h,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Text(
                    "Select a Country",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlue,
                      fontSize: 20.0.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.sp),
                Expanded(
                    child: AllCountryList(
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

class AllCountryList extends StatefulWidget {
  const AllCountryList({Key? key, required this.onSelect}) : super(key: key);

  final void Function(Country value) onSelect;

  @override
  State<AllCountryList> createState() => _AllCountryListState();
}

class _AllCountryListState extends State<AllCountryList> {
  late Future<List<Country>> country;
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    country = getAllCountries();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  OutlineInputBorder get border => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.darkBlue.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
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
              cursorColor: AppColors.darkBlue.withOpacity(0.2),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 10.w,
                  ),
                  child: Assets.images.icLocation.svg(),
                ),
                hintStyle: TextStyle(
                  color: AppColors.darkBlue.withOpacity(0.2),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
                hintText: "Search a Country",
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: country,
              builder: (context, AsyncSnapshot<List<Country>> snapshot) {
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
                                  "${element.flag} ${element.phoneCode.contains("+") ? element.phoneCode : "+${element.phoneCode}"} ${element.name}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkBlue,
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
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.lightYellow),
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
