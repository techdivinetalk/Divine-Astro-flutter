import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../model/kundli/KundaliPlanetDataModel.dart';
import '../../../repository/kundli_repository.dart';
import '../../../utils/utils.dart';
import 'drop_down_widget_screen.dart';
import 'kundli_detail_controller.dart';
import 'widgets/basic_panchang_ui.dart';
import 'widgets/dasha_ui.dart';
import 'widgets/dosha_ui.dart';
import 'widgets/kp_ui.dart';
import 'widgets/lagna_ui.dart';
import 'widgets/moon_chart_ui.dart';
import 'widgets/navamansha_ui.dart';
import 'widgets/personal_detail.dart';
import 'widgets/prediction_ui.dart';
import 'widgets/sun_chart_ui.dart';

class KundliDetailUi extends GetView<KundliDetailController> {
  const KundliDetailUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder<KundliDetailController>(
      assignId: true,
      init: KundliDetailController(KundliRepository()),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appColors.white,
            title: Text(
              controller.appBarName.tr,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                color: appColors.textColor,
              ),
            ),
          ),
          // body: SingleChildScrollView(
          //   controller: controller.scrollController,
          //   child: Column(
          //     children: [
          //       TabBarWidget(controller),
          //       Align(
          //         alignment: Alignment.topLeft,
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //             left: 14,
          //           ),
          //           child: Text(
          //             "Kundali Details",
          //             textAlign: TextAlign.start,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w600,
          //               fontSize: 16.sp,
          //               color: appColors.textColor,
          //             ),
          //           ),
          //         ),
          //       ),
          //       GridView.builder(
          //         shrinkWrap: true,
          //         controller: controller.scrollController,
          //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 3, // Number of columns in the grid
          //           crossAxisSpacing: 2, // Horizontal space between grid items
          //           mainAxisSpacing: 8, // Vertical space between grid items
          //           mainAxisExtent: 35,
          //         ),
          //         padding: const EdgeInsets.only(
          //             left: 4, right: 4, top: 8, bottom: 20),
          //         itemCount: controller
          //             .detailsPagesNames.length, // Number of items in the grid
          //         itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.only(left: 4, right: 4),
          //             child: InkWell(
          //               onTap: () {
          //                 controller
          //                     .changingTab(controller.detailsPagesNames[index]);
          //               },
          //               child: Container(
          //                 height: 35,
          //                 width: 70,
          //                 decoration: BoxDecoration(
          //                   color: controller.selectedTab ==
          //                           controller.detailsPagesNames[index]
          //                       ? appColors.red
          //                       : appColors.white,
          //                   borderRadius: BorderRadius.circular(14),
          //                   border: Border.all(
          //                     color: appColors.red,
          //                     width: 1,
          //                   ),
          //                 ),
          //                 child: Center(
          //                   child: Text(
          //                     controller.detailsPagesNames[index].toString(),
          //                     textAlign: TextAlign.center,
          //                     maxLines: 2,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.w600,
          //                       fontSize: 12.sp,
          //                       color: controller.selectedTab ==
          //                               controller.detailsPagesNames[index]
          //                           ? appColors.white
          //                           : appColors.red,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //       controller.kundaliPlanetDetails.value.data?.data?.isEmpty ??
          //               true
          //           ? SizedBox()
          //           : Align(
          //               alignment: Alignment.topLeft,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                   left: 14,
          //                 ),
          //                 child: Text(
          //                   "Planets Details",
          //                   textAlign: TextAlign.start,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: 16.sp,
          //                     color: appColors.textColor,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //       controller.kundaliPlanetDetails.value.data?.data?.isEmpty ??
          //               true
          //           ? SizedBox()
          //           : GridView.builder(
          //               shrinkWrap: true,
          //               controller: controller.scrollController,
          //               gridDelegate:
          //                   const SliverGridDelegateWithFixedCrossAxisCount(
          //                 crossAxisCount: 3, // Number of columns in the grid
          //                 crossAxisSpacing:
          //                     2, // Horizontal space between grid items
          //                 mainAxisSpacing:
          //                     8, // Vertical space between grid items
          //                 mainAxisExtent: 40,
          //               ),
          //               padding: const EdgeInsets.only(
          //                   left: 4, right: 4, top: 8, bottom: 20),
          //               itemCount: controller.kundaliPlanetDetails.value.data!
          //                   .data!.length, // Number of items in the grid
          //               itemBuilder: (context, index) {
          //                 var data = controller
          //                     .kundaliPlanetDetails.value.data!.data![index];
          //                 var key = data.name;
          //                 var name =
          //                     controller.kundaliPlanetDetails.value.data!.color;
          //                 return Padding(
          //                   padding: const EdgeInsets.only(left: 4, right: 4),
          //                   child: Container(
          //                     height: 35,
          //                     width: 70,
          //                     decoration: BoxDecoration(
          //                       color: appColors.white,
          //                       borderRadius: BorderRadius.circular(14),
          //                       border: Border.all(
          //                         color: key == "Sun"
          //                             ? Utils().hexToColor(name!.sun.toString())
          //                             : key == "Moon"
          //                                 ? Utils()
          //                                     .hexToColor(name!.moon.toString())
          //                                 : key == "Ascendant"
          //                                     ? Utils().hexToColor(
          //                                         name!.ascendant.toString())
          //                                     : key == "Mars"
          //                                         ? Utils().hexToColor(
          //                                             name!.mars.toString())
          //                                         : key == "Mercury"
          //                                             ? Utils().hexToColor(name!
          //                                                 .mercury
          //                                                 .toString())
          //                                             : key == "Venues"
          //                                                 ? Utils().hexToColor(
          //                                                     name!.venus
          //                                                         .toString())
          //                                                 : key == "Saturn"
          //                                                     ? Utils().hexToColor(
          //                                                         name!.saturn
          //                                                             .toString())
          //                                                     : key == "Rahu"
          //                                                         ? Utils().hexToColor(
          //                                                             name!.rahu
          //                                                                 .toString())
          //                                                         : key ==
          //                                                                 "Ketu"
          //                                                             ? Utils().hexToColor(name!
          //                                                                 .ketu
          //                                                                 .toString())
          //                                                             : key == "Jupiter"
          //                                                                 ? Utils().hexToColor(name!.jupiter.toString())
          //                                                                 : Colors.black,
          //                         width: 1,
          //                       ),
          //                     ),
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(3.0),
          //                       child: Center(
          //                         child: Text(
          //                           "${data.name.toString()} ${data.isRetro.toString() == "true" || data.isRetro.toString() == true ? "(R)" : ""} ${data.normDegree.toString().substring(0, 4)}°",
          //                           textAlign: TextAlign.center,
          //                           maxLines: 2,
          //                           overflow: TextOverflow.ellipsis,
          //                           style: TextStyle(
          //                             fontWeight: FontWeight.w600,
          //                             fontSize: 14.sp,
          //                             color: key == "Sun"
          //                                 ? Utils()
          //                                     .hexToColor(name!.sun.toString())
          //                                 : key == "Moon"
          //                                     ? Utils().hexToColor(
          //                                         name!.moon.toString())
          //                                     : key == "Ascendant"
          //                                         ? Utils().hexToColor(name!
          //                                             .ascendant
          //                                             .toString())
          //                                         : key == "Mars"
          //                                             ? Utils().hexToColor(
          //                                                 name!.mars.toString())
          //                                             : key == "Mercury"
          //                                                 ? Utils().hexToColor(
          //                                                     name!.mercury
          //                                                         .toString())
          //                                                 : key == "Venues"
          //                                                     ? Utils().hexToColor(
          //                                                         name!.venus
          //                                                             .toString())
          //                                                     : key == "Saturn"
          //                                                         ? Utils().hexToColor(name!
          //                                                             .saturn
          //                                                             .toString())
          //                                                         : key ==
          //                                                                 "Rahu"
          //                                                             ? Utils().hexToColor(name!
          //                                                                 .rahu
          //                                                                 .toString())
          //                                                             : key ==
          //                                                                     "Ketu"
          //                                                                 ? Utils().hexToColor(name!.ketu.toString())
          //                                                                 : key == "Jupiter"
          //                                                                     ? Utils().hexToColor(name!.jupiter.toString())
          //                                                                     : Colors.black,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 );
          //               },
          //             ),
          //     ],
          //   ),
          // ),
          body: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              children: [
                controller.dropdownData.contains(controller.appBarName)
                    ? TabBarWidget2(controller)
                    : TabBarWidget(controller),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: appColors.red,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 8),
                      child: DropdownButton(
                        isExpanded: true,
                        menuMaxHeight: 200,
                        borderRadius: BorderRadius.circular(14),
                        underline: SizedBox(),

                        hint: Text(
                          'Please select Chart',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: appColors.black,
                          ),
                        ), // Not necessary for Option 1

                        value: controller.selectedDrop,
                        onChanged: (newValue) {
                          if (newValue == "All Charts Available Here") {
                          } else {
                            controller.changeMaintap(newValue);
                          }
                        },
                        items: controller.dropdownData.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: appColors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Kundali Details",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.textColor,
                      ),
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  controller: controller.scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns in the grid
                    crossAxisSpacing: 2, // Horizontal space between grid items
                    mainAxisSpacing: 8, // Vertical space between grid items
                    mainAxisExtent: 35,
                  ),
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, top: 8, bottom: 20),
                  itemCount: controller
                      .detailsPagesNames.length, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: InkWell(
                        onTap: () {
                          controller
                              .changingTab(controller.detailsPagesNames[index]);
                        },
                        child: Container(
                          height: 35,
                          width: 70,
                          decoration: BoxDecoration(
                            color: controller.appBarName ==
                                    controller.detailsPagesNames[index]
                                ? appColors.red
                                : appColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: appColors.red,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.detailsPagesNames[index].toString(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                color: controller.appBarName ==
                                        controller.detailsPagesNames[index]
                                    ? appColors.white
                                    : appColors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                controller.kundaliPlanetDetails.value.data?.data?.isEmpty ??
                        true
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(),
                          child: Text(
                            "Planets Details",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: appColors.textColor,
                            ),
                          ),
                        ),
                      ),
                controller.kundaliPlanetDetails.value.data?.data?.isEmpty ??
                        true ||
                            controller.kundaliPlanetDetails.value == null ||
                            controller.kundaliPlanetDetails.value ==
                                KundaliPlanetDataModel()
                    ? const SizedBox()
                    : GridView.builder(
                        shrinkWrap: true,
                        controller: controller.scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns in the grid
                          crossAxisSpacing:
                              2, // Horizontal space between grid items
                          mainAxisSpacing:
                              8, // Vertical space between grid items
                          mainAxisExtent: 40,
                        ),
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, top: 8, bottom: 20),
                        itemCount: controller.kundaliPlanetDetails.value.data!
                            .data!.length, // Number of items in the grid
                        itemBuilder: (context, index) {
                          var data = controller
                              .kundaliPlanetDetails.value.data!.data![index];
                          var key = data.name;
                          var name =
                              controller.kundaliPlanetDetails.value.data!.color;
                          return Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Container(
                              height: 35,
                              width: 70,
                              decoration: BoxDecoration(
                                color: appColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: key == "Sun"
                                      ? Utils().hexToColor(name!.sun.toString())
                                      : key == "Moon"
                                          ? Utils()
                                              .hexToColor(name!.moon.toString())
                                          : key == "Ascendant"
                                              ? Utils().hexToColor(
                                                  name!.ascendant.toString())
                                              : key == "Mars"
                                                  ? Utils().hexToColor(
                                                      name!.mars.toString())
                                                  : key == "Mercury"
                                                      ? Utils().hexToColor(name!
                                                          .mercury
                                                          .toString())
                                                      : key == "Venues"
                                                          ? Utils().hexToColor(
                                                              name!.venus
                                                                  .toString())
                                                          : key == "Saturn"
                                                              ? Utils().hexToColor(
                                                                  name!.saturn
                                                                      .toString())
                                                              : key == "Rahu"
                                                                  ? Utils().hexToColor(
                                                                      name!.rahu
                                                                          .toString())
                                                                  : key ==
                                                                          "Ketu"
                                                                      ? Utils().hexToColor(name!
                                                                          .ketu
                                                                          .toString())
                                                                      : key == "Jupiter"
                                                                          ? Utils().hexToColor(name!.jupiter.toString())
                                                                          : Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Center(
                                  child: Text(
                                    "${data.name.toString()}${data.isRetro.toString() == "true" || data.isRetro.toString() == true ? "(R)" : ""} ${data.normDegree.toString().substring(0, 4)}°",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: key == "Sun"
                                          ? Utils()
                                              .hexToColor(name!.sun.toString())
                                          : key == "Moon"
                                              ? Utils().hexToColor(
                                                  name!.moon.toString())
                                              : key == "Ascendant"
                                                  ? Utils().hexToColor(name!
                                                      .ascendant
                                                      .toString())
                                                  : key == "Mars"
                                                      ? Utils().hexToColor(
                                                          name!.mars.toString())
                                                      : key == "Mercury"
                                                          ? Utils().hexToColor(
                                                              name!.mercury
                                                                  .toString())
                                                          : key == "Venues"
                                                              ? Utils().hexToColor(
                                                                  name!.venus
                                                                      .toString())
                                                              : key == "Saturn"
                                                                  ? Utils().hexToColor(name!
                                                                      .saturn
                                                                      .toString())
                                                                  : key ==
                                                                          "Rahu"
                                                                      ? Utils().hexToColor(name!
                                                                          .rahu
                                                                          .toString())
                                                                      : key ==
                                                                              "Ketu"
                                                                          ? Utils().hexToColor(name!.ketu.toString())
                                                                          : key == "Jupiter"
                                                                              ? Utils().hexToColor(name!.jupiter.toString())
                                                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
  //chart

  TabBarWidget(controller) {
    if (controller.appBarName == "Lagna") {
      return LagnaUi(controller: controller);
    } else if (controller.appBarName == "Personal Details") {
      return PersonalDetailUi(controller: controller);
    } else if (controller.appBarName == "Navamasha") {
      return NavamanshaUi(controller: controller);
    } else if (controller.appBarName == "Sun") {
      return SunChartUi(controller: controller);
    } else if (controller.appBarName == "Moon") {
      return MoonChartUi(controller: controller);
    } else if (controller.appBarName == "Kp") {
      return KpUI(controller: controller);
    } else if (controller.appBarName == "Dasha") {
      return DashaUI(controller: controller);
    } else if (controller.appBarName == "Dosha") {
      return DoshaUi(controller: controller);
    } else if (controller.appBarName == "Basic Panchang") {
      return BasicPanchangUi(controller: controller);
    } else if (controller.appBarName == "Prediction") {
      return PredictionUi(controller: controller);
    } else {
      return Container();
    }
  }

  TabBarWidget2(controller) {
    if (controller.appBarName == "Chalit Chart") {
      return ChalitChartUi(controller: controller);
    } else if (controller.appBarName == "Sun Chart" ||
        controller.appBarName == "Sun") {
      return SunChartUi(controller: controller);
    } else if (controller.appBarName == "Moon Chart" ||
        controller.appBarName == "Moon") {
      return MoonChartUi(controller: controller);
    } else if (controller.appBarName == "D1 : For Brith Chart") {
      return BrithChartUi(controller: controller);
    } else if (controller.appBarName == "D2 : For Hora Chart") {
      return HoraChartUi(controller: controller);
    } else if (controller.appBarName == "D3 : For Dreshkan Chart") {
      return DreshkanChartUi(controller: controller);
    } else if (controller.appBarName == "D4 : For Chathurthamasha Chart") {
      return ChathurthamashaChartUi(controller: controller);
    } else if (controller.appBarName == "D5 : For Panchmansha Chart") {
      return PanchmanshaChartUi(controller: controller);
    } else if (controller.appBarName == "D7 : For Saptamansha Chart") {
      return SaptamanshaChartUi(controller: controller);
    } else if (controller.appBarName == "D8 : For Ashtamansha Chart") {
      return AshtamanshaChartUi(controller: controller);
    } else if (controller.appBarName == "D9 : For Navamansha Chart") {
      return NavamanshaUi(controller: controller);
    } else if (controller.appBarName == "D10 : For Dashamansha Chart") {
      return DashamanshaChartUi(controller: controller);
    } else if (controller.appBarName == "D12 : For Dwadashamsha Chart") {
      return DwadashamshaChartUi(controller: controller);
    } else if (controller.appBarName == "D16 : For Shodashamsha Chart") {
      return ShodashamshaChartUi(controller: controller);
    } else if (controller.appBarName == "D20 : For Vishamansha Chart") {
      return VishamanshaChartUi(controller: controller);
    } else if (controller.appBarName == "D24 : For Chaturvimshamsha Chart") {
      return ChaturvimshamshaChartUi(controller: controller);
    } else if (controller.appBarName == "D27 : For Bhamsha Chart") {
      return BhamshaChartUi(controller: controller);
    } else if (controller.appBarName == "D30 : For Trishamansha Chart") {
      return TrishamanshaChartUi(controller: controller);
    } else if (controller.appBarName == "D40 : For Khavedamsha Chart") {
      return KhavedamshaChartUi(controller: controller);
    } else if (controller.appBarName == "D45 : For Akshvedansha Chart") {
      return AkshvedanshaChartUi(controller: controller);
    } else if (controller.appBarName == "D60 : For Shashtymsha Chart") {
      return ShashtymshaChartUi(controller: controller);
    } else {
      return Container();
    }
  }
  // TabBarWidget(controller) {
  //   if (controller.selectedTab == "Lagna") {
  //     return LagnaUi(controller: controller);
  //   } else if (controller.selectedTab == "Personal Details") {
  //     return PersonalDetailUi(controller: controller);
  //   } else if (controller.selectedTab == "Navamasha") {
  //     return NavamanshaUi(controller: controller);
  //   } else if (controller.selectedTab == "Sun") {
  //     return SunChartUi(controller: controller);
  //   } else if (controller.selectedTab == "Moon") {
  //     return MoonChartUi(controller: controller);
  //   } else if (controller.selectedTab == "Kp") {
  //     return KpUI(controller: controller);
  //   } else if (controller.selectedTab == "Dasha") {
  //     return DashaUI(controller: controller);
  //   } else if (controller.selectedTab == "Dosha") {
  //     return DoshaUi(controller: controller);
  //   } else if (controller.selectedTab == "Basic Panchang") {
  //     return BasicPanchangUi(controller: controller);
  //   } else if (controller.selectedTab == "Prediction") {
  //     return PredictionUi(controller: controller);
  //   }
  // }
}

// import 'package:divine_astrologer/common/app_textstyle.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../common/colors.dart';
// import '../../../gen/assets.gen.dart';
// import 'kundli_detail_controller.dart';
// import 'widgets/basic_panchang_ui.dart';
// import 'widgets/dasha_ui.dart';
// import 'widgets/dosha_ui.dart';
// import 'widgets/kp_ui.dart';
// import 'widgets/lagna_ui.dart';
// import 'widgets/moon_chart_ui.dart';
// import 'widgets/navamansha_ui.dart';
// import 'widgets/personal_detail.dart';
// import 'widgets/prediction_ui.dart';
// import 'widgets/sun_chart_ui.dart';
//
// class KundliDetailUi extends GetView<KundliDetailController> {
//   const KundliDetailUi({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 10,
//         child: Builder(builder: (context) {
//           var defaultController = DefaultTabController.of(context);
//           defaultController.addListener(() {
//             controller.currentIndex.value = defaultController.index;
//           });
//           return NestedScrollView(
//             headerSliverBuilder: (context, value) {
//               return [
//                 SliverOverlapAbsorber(
//                   handle:
//                       NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                   sliver: SliverAppBar(
//                     leading: InkWell(
//                       onTap: () => Get.back(),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8),
//                         child: Center(child: Assets.images.icLeftArrow.svg()),
//                       ),
//                     ),
//                     flexibleSpace: FlexibleSpaceBar(
//                         stretchModes: const <StretchMode>[
//                           StretchMode.blurBackground,
//                         ],
//                         background: Stack(
//                           children: [
//                             Center(
//                               child: Assets.images.bgKundliDetail
//                                   .svg(width: 128.w, height: 128.h),
//                             ),
//                             Obx(() => Center(
//                                   child: controller.detailPageImage[
//                                       controller.currentIndex.value],
//                                 )),
//                           ],
//                         )),
//                     surfaceTintColor: appColors.white,
//                     expandedHeight: 280.h,
//                     pinned: true,
//                     title: Text("kundliText".tr,
//                         style: AppTextStyle.textStyle16(
//                             fontWeight: FontWeight.w400,
//                             fontColor: appColors.darkBlue)),
//                     bottom: PreferredSize(
//                       preferredSize: const Size.fromHeight(kTextTabBarHeight),
//                       child: Card(
//                         surfaceTintColor: appColors.white,
//                         margin: EdgeInsets.zero,
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.zero),
//                         child: Center(
//                           child: TabBar(
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             indicatorWeight: 0.0,
//                             isScrollable: true,
//                             dividerColor: Colors.transparent,
//                             labelPadding: EdgeInsets.zero,
//                             labelColor: appColors.whiteGuidedColor,
//                             unselectedLabelColor: appColors.blackColor,
//                             splashBorderRadius: BorderRadius.circular(20),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 6.w, horizontal: 24.w),
//                             labelStyle: AppTextStyle.textStyle14(
//                                 fontWeight: FontWeight.w500,
//                                 fontColor: appColors.whiteGuidedColor),
//                             indicator: BoxDecoration(
//                               color: appColors.guideColor,
//                               borderRadius: BorderRadius.circular(28),
//                             ),
//                             onTap: (value) {
//                               controller.currentIndex.value = value;
//                               controller.getApiData(
//                                   Get.arguments['from_kundli'],
//                                   tab: value);
//                             },
//                             tabs: [
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "personalDetails".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "lagna".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "moon".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "sun".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "navamansha".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "dosha".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "kp".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "dasha".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "basicPanchang".tr),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                                 child: Tab(text: "prediction".tr),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ];
//             },
//             body: TabBarView(
//               children: [
//                 PersonalDetailUi(controller: controller),
//                 LagnaUi(controller: controller),
//                 MoonChartUi(controller: controller),
//                 SunChartUi(controller: controller),
//                 NavamanshaUi(controller: controller),
//                 DoshaUi(controller: controller),
//                 KpUI(controller: controller),
//                 DashaUI(controller: controller),
//                 BasicPanchangUi(controller: controller),
//                 PredictionUi(controller: controller),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
