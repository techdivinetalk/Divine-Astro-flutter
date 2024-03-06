// import "dart:async";
// import "dart:ui";

// import "package:after_layout/after_layout.dart";
// import "package:divine_astrologer/common/colors.dart";
// import "package:divine_astrologer/common/generic_loading_widget.dart";
// import "package:divine_astrologer/di/shared_preference_service.dart";
// import "package:divine_astrologer/model/live/get_astrologer_ecom_res.dart";
// import "package:divine_astrologer/repository/astrologer_profile_repository.dart";
// import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
// import "package:expandable_text/expandable_text.dart";
// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
// import "package:fluttertoast/fluttertoast.dart";
// import "package:get/get.dart";
// import "package:get/get_connect/http/src/status/http_status.dart";

// class LiveShopWidget extends StatefulWidget {
//   const LiveShopWidget({
//     required this.onClose,
//     required this.liveId,
//     super.key,
//   });

//   final void Function() onClose;
//   final String liveId;

//   @override
//   State<LiveShopWidget> createState() => _LiveShopWidgetState();
// }

// class _LiveShopWidgetState extends State<LiveShopWidget>
//     with AfterLayoutMixin<LiveShopWidget> {
//   final SharedPreferenceService pref = Get.put(SharedPreferenceService());

//   final AstrologerProfileRepository liveRepository =
//       AstrologerProfileRepository();

//   final Rx<GetAstrologerEcomResponse> _getAstrologerEcomResponse =
//       GetAstrologerEcomResponse().obs;

//   GetAstrologerEcomResponse get ecomResponse =>
//       _getAstrologerEcomResponse.value;
//   set ecomResponse(GetAstrologerEcomResponse value) =>
//       _getAstrologerEcomResponse(value);

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: appColors.transparent,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[top(), const SizedBox(height: 16), bottom()],
//       ),
//     );
//   }

//   Widget top() {
//     return InkWell(
//       onTap: widget.onClose,
//       borderRadius: const BorderRadius.all(Radius.circular(50.0)),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//         child: Container(
//           height: 48,
//           width: 48,
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(50.0)),
//             border: Border.all(color: appColors.white),
//             color: appColors.white.withOpacity(0.2),
//           ),
//           child: Icon(Icons.close, color: appColors.white),
//         ),
//       ),
//     );
//   }

//   Widget bottom() {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(50.0),
//         topRight: Radius.circular(50.0),
//       ),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//         child: Container(
//           height: Get.height / 1.50,
//           width: Get.width,
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(50.0),
//               topRight: Radius.circular(50.0),
//             ),
//             border: Border.all(color: appColors.guideColor),
//             color: appColors.white.withOpacity(0.2),
//           ),
//           child: grid(),
//         ),
//       ),
//     );
//   }

//   Widget grid() {
//     return Obx(
//       () {
//         return mapEquals(
//           ecomResponse.toJson(),
//           GetAstrologerEcomResponse().toJson(),
//         )
//             ? const Center(
//                 child: GenericLoadingWidget(),
//               )
//             : (ecomResponse.data?.length ?? 0) == 0
//                 ? Center(
//                     child: Text(
//                       "No product available at the shop at this time.",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: appColors.white,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   )
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: ecomResponse.data?.length,
//                     padding: const EdgeInsets.only(top: 16),
//                     itemBuilder: (BuildContext context, int index) {
//                       final Data item = ecomResponse.data?[index] ?? Data();
//                       final startPoint = pref.getAmazonUrl() ?? "";
//                       final endPoint = item.poojaImg ?? "";
//                       final String poojaImg = "$startPoint$endPoint";
//                       return Stack(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 8.0,
//                               vertical: 4.0,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(10.0),
//                               ),
//                               border: Border.all(color: appColors.guideColor),
//                               color: appColors.white,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 children: [
//                                   Column(
//                                     children: [
//                                       SizedBox(
//                                         height: 64,
//                                         width: 64,
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           child: CustomImageWidget(
//                                             imageUrl: poojaImg,
//                                             rounded: false,
//                                             typeEnum: TypeEnum.pooja,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Flexible(
//                                               child: Text(
//                                                 item.poojaName ?? "",
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Flexible(
//                                               child: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                   vertical: 2,
//                                                   horizontal: 4,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: appColors.textColor,
//                                                   borderRadius:
//                                                       const BorderRadius.all(
//                                                     Radius.circular(10.0),
//                                                   ),
//                                                 ),
//                                                 child: Flexible(
//                                                   child: Text(
//                                                     item.tag ?? "",
//                                                     style: TextStyle(
//                                                       fontSize: 10,
//                                                       color: appColors.white,
//                                                     ),
//                                                     maxLines: 1,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           "₹ ${item.poojaStartingPriceInr ?? ""}",
//                                           style: const TextStyle(
//                                             fontSize: 12,
//                                           ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         const SizedBox(height: 8),
//                                         ExpandableText(
//                                           item.poojaDesc ?? "",
//                                           expandText: 'Know More',
//                                           collapseText: 'Show Less',
//                                           maxLines: 2,
//                                           style: const TextStyle(
//                                             fontSize: 10,
//                                           ),
//                                           linkColor: Colors.blue,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Column(
//                                     children: [
//                                       const SizedBox(height: 32),
//                                       moreOptionsButton2(
//                                         buttonText: "Book Now",
//                                         buttonCallback: () {},
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 4,
//                             right: 24,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 2,
//                                 horizontal: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: appColors.red,
//                                 borderRadius: const BorderRadius.only(
//                                   bottomLeft: Radius.circular(10),
//                                   bottomRight: Radius.circular(10),
//                                 ),
//                               ),
//                               child: Text(
//                                 "${item.result ?? ""}% Result",
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: appColors.white,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           )
//                         ],
//                       );
//                     },
//                   );
//       },
//     );
//   }

//   Widget moreOptionsButton2({
//     required String buttonText,
//     required Function() buttonCallback,
//   }) {
//     return SizedBox(
//       width: 70,
//       child: OutlinedButton(
//         style: ButtonStyle(
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           minimumSize: const MaterialStatePropertyAll(Size(56, 32)),
//           padding: MaterialStateProperty.all(EdgeInsets.zero),
//           elevation: MaterialStateProperty.all(4),
//           backgroundColor: MaterialStateProperty.all(appColors.white),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//               side: BorderSide(width: 1, color: appColors.green),
//             ),
//           ),
//         ),
//         onPressed: buttonCallback,
//         child: Text(
//           buttonText,
//           style: TextStyle(
//             color: appColors.green,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> getAstrologerEcom({
//     required Function(String message) successCallBack,
//     required Function(String message) failureCallBack,
//   }) async {
//     Map<String, dynamic> params = <String, dynamic>{};
//     params = <String, dynamic>{"astrologer_id": widget.liveId};
//     GetAstrologerEcomResponse res = GetAstrologerEcomResponse();
//     res = await liveRepository.getAstrologerEcomAPI(
//       params: params,
//       successCallBack: successCallBack,
//       failureCallBack: failureCallBack,
//     );
//     ecomResponse = res.statusCode == HttpStatus.ok
//         ? GetAstrologerEcomResponse.fromJson(res.toJson())
//         : GetAstrologerEcomResponse.fromJson(
//             GetAstrologerEcomResponse().toJson());
//     return Future<void>.value();
//   }

//   @override
//   FutureOr<void> afterFirstLayout(BuildContext context) async {
//     await getAstrologerEcom(
//       successCallBack: (String message) async {},
//       failureCallBack: (String message) async {
//         await Fluttertoast.showToast(
//           msg: message,
//           backgroundColor: Colors.red,
//         );
//       },
//     );
//     return Future.value();
//   }
// }
