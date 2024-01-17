// import "dart:ui";

// import "package:divine_app/common/colors.dart";
// import "package:divine_app/model/live/get_astrologer_details_response.dart";
// import "package:divine_app/screens/live_dharam/live_dharam_controller.dart";
// import "package:divine_app/screens/live_dharam/widgets/custom_image_widget.dart";
// import "package:flutter/material.dart";
// import "package:get/get.dart";

// class CallAstrologerWidget extends StatefulWidget {
//   const CallAstrologerWidget({
//     required this.onClose,
//     required this.waitTime,
//     required this.details,
//     required this.onSelect,
//     required this.list,
//     super.key,
//   });

//   final void Function() onClose;
//   final String waitTime;
//   final GetAstroDetailsRes details;
//   // final void Function(String type, int amount) onSelect;
//   final void Function(String type) onSelect;
//   final List<WaitListModel> list;

//   @override
//   State<CallAstrologerWidget> createState() => _CallAstrologerWidgetState();
// }

// class _CallAstrologerWidgetState extends State<CallAstrologerWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.transparent,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[top(), const SizedBox(height: 64), bottom()],
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
//             border: Border.all(color: AppColors.white),
//             color: AppColors.white.withOpacity(0.2),
//           ),
//           child: const Icon(Icons.close, color: AppColors.white),
//         ),
//       ),
//     );
//   }

//   Widget bottom() {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: <Widget>[
//         ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(50.0),
//             topRight: Radius.circular(50.0),
//           ),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//             child: Container(
//               // height: Get.height / 1.50,
//               width: Get.width,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(50.0),
//                   topRight: Radius.circular(50.0),
//                 ),
//                 border: Border.all(color: AppColors.yellow),
//                 color: AppColors.white,
//               ),
//               child: grid(),
//             ),
//           ),
//         ),
//         Positioned(
//           top: -50,
//           left: 0,
//           right: 0,
//           child: SizedBox(
//             height: 100,
//             width: 100,
//             child: CustomImageWidget(
//               imageUrl: widget.details.data?.image ?? "",
//               rounded: true,
//               typeEnum: TypeEnum.user,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget grid() {
//     // final Data data = widget.details.data ?? Data();
//     // final int videoDiscount = data.videoDiscountedAmount ?? 0;
//     // final int videoOriginal = data.videoCallAmount ?? 0;
//     // final int audioDiscount = data.audioDiscountedAmount ?? 0;
//     // final int audioOriginal = data.audioCallAmount ?? 0;
//     // final int privateDiscount = data.anonymousDiscountedAmount ?? 0;
//     // final int privateOriginal = data.anonymousCallAmount ?? 0;

//     String singleColumn0 = "";
//     String doubleColumn1 = "";
//     String doubleColumn2 = "";
//     String doubleColumn3 = "";

//     final Data data = widget.details.data ?? Data();
//     final OfferDetails offerDetails = data.offerDetails ?? OfferDetails();
//     final bool isOfferAvailable = offerDetails.offerId != null;

//     final int videoOriginal = data.videoCallAmount ?? 0;
//     final int audioOriginal = data.audioCallAmount ?? 0;
//     final int privateOriginal = data.anonymousCallAmount ?? 0;

//     final List<int> originalList = [
//       videoOriginal,
//       audioOriginal,
//       privateOriginal,
//     ];
//     originalList.sort(
//       (a, b) {
//         return a.compareTo(b);
//       },
//     );

//     if (isOfferAvailable) {
//       if (offerDetails.specialOfferText != null) {
//         doubleColumn1 = offerDetails.specialOfferText ?? "";
//         doubleColumn2 = offerDetails.offerText ?? "";
//         doubleColumn3 = originalList.first.toString();
//       } else {
//         doubleColumn1 = offerDetails.offerText ?? "";
//         doubleColumn2 = originalList.first.toString();
//       }
//     } else {
//       singleColumn0 = originalList.first.toString();
//     }

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             const SizedBox(height: 64 - 16),
//             Text(
//               data.name ?? "",
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               data.speciality ?? "",
//               style: const TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//             const SizedBox(height: 8),
//             widget.list.length > 1
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.asset("assets/images/live_mini_hourglass.png"),
//                       const SizedBox(width: 4),
//                       const Text("Wait Time - "),
//                       const SizedBox(width: 4),
//                       Text(widget.waitTime),
//                     ],
//                   )
//                 : const SizedBox(),
//             SizedBox(height: widget.list.length > 1 ? 8 : 0),
//             SizedBox(height: offerDetails.offerDesc != null ? 16 : 0),
//             Text(offerDetails.offerDesc ?? ""),
//             SizedBox(height: offerDetails.offerDesc != null ? 16 : 0),
//             const Divider(height: 1, thickness: 1),
//             listTile(
//               asset: "assets/images/live_call_video.png",
//               type: "Video",
//               singleColumn0: singleColumn0,
//               doubleColumn1: doubleColumn1,
//               doubleColumn2: doubleColumn2,
//               doubleColumn3: doubleColumn3,
//               isOfferAvailable: isOfferAvailable,
//               offerDetails: offerDetails,
//               videoOriginal: videoOriginal,
//               audioOriginal: audioOriginal,
//               privateOriginal: privateOriginal,
//               subtitle: "Both consultant and you on video call",
//               buttonText: "Join",
//             ),
//             const Divider(height: 1, thickness: 1),
//             listTile(
//               asset: "assets/images/live_call_audio.png",
//               type: "Audio",
//               singleColumn0: singleColumn0,
//               doubleColumn1: doubleColumn1,
//               doubleColumn2: doubleColumn2,
//               doubleColumn3: doubleColumn3,
//               isOfferAvailable: isOfferAvailable,
//               offerDetails: offerDetails,
//               videoOriginal: videoOriginal,
//               audioOriginal: audioOriginal,
//               privateOriginal: privateOriginal,
//               subtitle: "Consultant on video and you on audio",
//               buttonText: "Join",
//             ),
//             const Divider(height: 1, thickness: 1),
//             listTile(
//               asset: "assets/images/live_call_private.png",
//               type: "Private",
//               singleColumn0: singleColumn0,
//               doubleColumn1: doubleColumn1,
//               doubleColumn2: doubleColumn2,
//               doubleColumn3: doubleColumn3,
//               isOfferAvailable: isOfferAvailable,
//               offerDetails: offerDetails,
//               videoOriginal: videoOriginal,
//               audioOriginal: audioOriginal,
//               privateOriginal: privateOriginal,
//               subtitle:
//                   // ignore: lines_longer_than_80_chars
//                   "Consultant on video, you on audio. No one can hear you, consultant is audible.",
//               buttonText: "Join",
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget listTile({
//     required String asset,
//     required String type,
//     required String singleColumn0,
//     required String doubleColumn1,
//     required String doubleColumn2,
//     required String doubleColumn3,
//     required String subtitle,
//     required String buttonText,
//     required bool isOfferAvailable,
//     required OfferDetails offerDetails,
//     required int videoOriginal,
//     required int audioOriginal,
//     required int privateOriginal,
//   }) {
//     return ListTile(
//       dense: true,
//       contentPadding: EdgeInsets.zero,
//       leading: Image.asset(asset),
//       title: textWidget(
//         type: type,
//         singleColumn0: singleColumn0,
//         doubleColumn1: doubleColumn1,
//         doubleColumn2: doubleColumn2,
//         doubleColumn3: doubleColumn3,
//         isOfferAvailable: isOfferAvailable,
//         offerDetails: offerDetails,
//         videoOriginal: videoOriginal,
//         audioOriginal: audioOriginal,
//         privateOriginal: privateOriginal,
//       ),
//       subtitle: Text(subtitle),
//       trailing: ElevatedButton(
//         style: ButtonStyle(
//           elevation: MaterialStateProperty.all(4),
//           backgroundColor: MaterialStateProperty.all(AppColors.yellow),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(50.0)),
//             ),
//           ),
//         ),
//         onPressed: () {
//           widget.onSelect(
//             type,
//             // discountAmount == 0 ? originalAmount : discountAmount,
//           );
//         },
//         child: Text(
//           buttonText,
//           style: const TextStyle(color: AppColors.black),
//         ),
//       ),
//     );
//   }

//   Widget textWidget({
//     required String type,
//     // required int discountAmount,
//     // required int originalAmount,
//     required String singleColumn0,
//     required String doubleColumn1,
//     required String doubleColumn2,
//     required String doubleColumn3,
//     required bool isOfferAvailable,
//     required OfferDetails offerDetails,
//     required int videoOriginal,
//     required int audioOriginal,
//     required int privateOriginal,
//   }) {
//     // return (discountAmount == 0)
//     //     ? Text(
//     //         "$type Call @ ₹$originalAmount/Min",
//     //         style: const TextStyle(
//     //           fontWeight: FontWeight.bold,
//     //         ),
//     //       )
//     //     : Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //         children: <Widget>[
//     //           Text(
//     //             "$type Call @ ₹$discountAmount/Min",
//     //             style: const TextStyle(
//     //               fontWeight: FontWeight.bold,
//     //             ),
//     //           ),
//     //           const SizedBox(width: 4.0),
//     //           Text(
//     //             "₹$originalAmount/Min",
//     //             style: const TextStyle(
//     //               fontSize: 10,
//     //               decoration: TextDecoration.lineThrough,
//     //               decorationColor: Colors.red,
//     //             ),
//     //           ),
//     //           const SizedBox(width: 4.0),
//     //         ],
//     //       );
//     if (isOfferAvailable) {
//       if (offerDetails.specialOfferText != null) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               "$type Call",
//               style: const TextStyle(
//                 fontSize: 12,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(width: 4),
//             const Text(
//               "@",
//               style: TextStyle(
//                 fontSize: 12,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               doubleColumn2,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               // "₹$doubleColumn3/Min",
//               "₹${typeBased(type: type, videoOriginal: videoOriginal, audioOriginal: audioOriginal, privateOriginal: privateOriginal)}/Min",
//               style: const TextStyle(
//                 fontSize: 12,
//                 decoration: TextDecoration.lineThrough,
//                 decorationColor: Colors.red,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         );
//       } else {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               "$type Call",
//               style: const TextStyle(
//                 fontSize: 12,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(width: 4),
//             const Text(
//               "@",
//               style: TextStyle(
//                 fontSize: 12,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               doubleColumn1,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               // "₹$doubleColumn2/Min",
//               "₹${typeBased(type: type, videoOriginal: videoOriginal, audioOriginal: audioOriginal, privateOriginal: privateOriginal)}/Min",
//               style: const TextStyle(
//                 decoration: TextDecoration.lineThrough,
//                 decorationColor: Colors.red,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         );
//       }
//     } else {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             "$type Call",
//             style: const TextStyle(
//               fontSize: 12,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(width: 4),
//           const Text(
//             "@",
//             style: TextStyle(
//               fontSize: 12,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(width: 4),
//           Text(
//             // "₹$singleColumn0/Min",
//             "₹${typeBased(type: type, videoOriginal: videoOriginal, audioOriginal: audioOriginal, privateOriginal: privateOriginal)}/Min",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       );
//     }
//   }

//   String typeBased({
//     required String type,
//     required int videoOriginal,
//     required int audioOriginal,
//     required int privateOriginal,
//   }) {
//     String val = "";
//     if (type == "Video") {
//       val = videoOriginal.toString();
//     } else {}
//     if (type == "Audio") {
//       val = audioOriginal.toString();
//     } else {}
//     if (type == "Private") {
//       val = privateOriginal.toString();
//     } else {}
//     return val;
//   }
// }
