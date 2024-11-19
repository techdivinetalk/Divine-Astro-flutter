import 'dart:convert';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../model/cityDataModel.dart';
import 'common_functions.dart';

Future<void> selectPlaceOfBirth(
    BuildContext context, void Function(CityStateData value) onSelect) async {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => SelectPlaceOfBirth(onSelect: onSelect),
  );
}

class SelectPlaceOfBirth extends StatelessWidget {
  const SelectPlaceOfBirth({Key? key, required this.onSelect})
      : super(key: key);

  final void Function(CityStateData value) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
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
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50.0)),
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
                      child: AllCityListSheet(
                    onSelect: onSelect,
                    country: "India",
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllCityListSheet extends StatefulWidget {
  const AllCityListSheet({
    Key? key,
    required this.onSelect,
    required this.country,
    this.cityData,
  }) : super(key: key);

  final void Function(CityStateData value) onSelect;

  final String country;
  final List<CityStateData>? cityData;

  @override
  State<AllCityListSheet> createState() => _AllCityListSheetState();
}

class _AllCityListSheetState extends State<AllCityListSheet> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  List<CityStateData> cityList = [];

  @override
  void initState() {
    // setState(() {});
    cityList = widget.cityData ?? [];
    super.initState();
  }

  getAllCity() async {
    List<CityStateData> cityListApi = [];

    Map<String, dynamic> param = {
      "country": "India",
      "place": controller.text,
    };
    try {
      final data = await userRepository.cityApi(param);
      if (data.data != null && data.data!.isNotEmpty) {
        cityListApi.addAll(data.data!);
        cityList = cityListApi;
        print(cityList.length);
        print("cityList.length");
      }
    } catch (e) {
      print('Error fetching city data: $e');
      // Handle the error here, e.g., show a snackbar or dialog to the user
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  OutlineInputBorder get border => OutlineInputBorder(
        borderSide: BorderSide(
          color: appColors.textColor.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Assets.svgs.createAccLocation.svg(
                    //   width: 30.w,
                    //   height: 35.h,
                    //   color: appColors.guideColor,
                    // ),
                    SizedBox(width: 16.w),
                    Text(
                      "please_select_city".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: appColors.textColor,
                        fontSize: 20.0.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.sp),
                Expanded(
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
                        child: Material(
                          child: TextField(
                            enabled: true,
                            autofocus: true,
                            controller: controller,
                            onChanged: (value) => setState(() {
                              if (value.length % 2 == 0) {
                                getAllCity();
                              }
                            }),
                            cursorColor: appColors.darkBlue.withOpacity(0.2),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.h),
                                prefixIcon: Center(child: Icon(Icons.search)),
                                prefixIconConstraints: const BoxConstraints(
                                    maxHeight: 50, maxWidth: 50),
                                hintStyle: TextStyle(
                                  color: appColors.textColor.withOpacity(0.2),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                                hintText: "Search your birthplace",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: appColors.textColor.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(27.sp),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: appColors.textColor.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(27.sp),
                                )),
                          ),
                        ),
                      ),
                      Text(
                        "Note :- After writing 4 letters you will get City",
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontWeight: FontWeight.w400,
                          color: appColors.guideColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: List.generate(cityList.length, (index) {
                            CityStateData data = cityList[index];
                            print(jsonDecode(jsonEncode(cityList))[index]
                                ["place"]);
                            print("data.name");
                            return InkWell(
                              onTap: () {
                                widget.onSelect(data);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 22.w,
                                ),
                                child: Text(
                                  data.cityName ?? "",
                                  style: TextStyle(
                                    fontFamily: FontFamily.poppins,
                                    fontWeight: FontWeight.w400,
                                    color: appColors.textColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

/* Future<void> getState() async {
    stateList.clear();
    cityList.clear();
    List<CityStateModel> subStateList = [];
    var jsonString = await rootBundle
        .loadString('assets/jsons/state.json');
    List<dynamic> body = json.decode(jsonString);

    subStateList =
        body.map((dynamic item) => CityStateModel.fromJson(item)).toList();
    for (var element in subStateList) {
      if (element.countryId == "101") {

          stateList.add(element);
        update();
      }
    }
    stateSubList = stateList;
  }*/
}

//
// class AllCitiesList extends StatefulWidget {
//   const AllCitiesList({Key? key, required this.onSelect}) : super(key: key);
//
//   final void Function(City value) onSelect;
//
//   @override
//   State<AllCitiesList> createState() => _AllCitiesListState();
// }
//
// class _AllCitiesListState extends State<AllCitiesList> {
//   late Future<List<City>> cities;
//   late final TextEditingController controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     ///"${Get.locale?.countryCode.toString()}"
//     cities = getCountryCities("IN");
//     controller = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }
//
//   OutlineInputBorder get border => OutlineInputBorder(
//         borderSide: BorderSide(
//           color: appColors.darkBlue.withOpacity(0.5),
//         ),
//         borderRadius: BorderRadius.circular(10.sp),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: appColors.white,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             margin: EdgeInsets.only(
//               left: 15.w,
//               right: 15.w,
//               top: 5.h,
//               bottom: 17.h,
//             ),
//             child: TextField(
//               enabled: true,
//               autofocus: true,
//               controller: controller,
//               onChanged: (value) => setState(() {}),
//               cursorColor: appColors.darkBlue.withOpacity(0.2),
//               decoration: InputDecoration(
//                 prefixIcon: Container(
//                   margin: EdgeInsets.symmetric(
//                     vertical: 15.h,
//                     horizontal: 10.w,
//                   ),
//                   child: Assets.images.createAccSearch.svg(),
//                 ),
//                 hintStyle: TextStyle(
//                   color: appColors.darkBlue.withOpacity(0.2),
//                   fontWeight: FontWeight.w400,
//                   fontSize: 16.sp,
//                 ),
//                 hintText: "searchPlaceBirth".tr,
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: cities,
//               builder: (context, AsyncSnapshot<List<City>> snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView(
//                     padding: EdgeInsets.zero,
//                     children: snapshot.data!
//                         .search(controller.text)
//                         .map<Widget>(
//                           (element) => Theme(
//                             data: ThemeData(useMaterial3: false),
//                             child: InkWell(
//                               onTap: () => widget.onSelect(element),
//                               child: Container(
//                                 margin: EdgeInsets.symmetric(
//                                   vertical: 10.h,
//                                   horizontal: 22.w,
//                                 ),
//                                 child: Text(
//                                   element.name,
//                                   style: TextStyle(
//                                     fontFamily: FontFamily.poppins,
//                                     fontWeight: FontWeight.w400,
//                                     color: appColors.darkBlue,
//                                     fontSize: 16.sp,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   );
//                 }
//                 return Center(
//                   child: CircularProgressIndicator.adaptive(
//                     strokeWidth: 2.sp,
//                     valueColor: AlwaysStoppedAnimation(appColors.guideColor),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
