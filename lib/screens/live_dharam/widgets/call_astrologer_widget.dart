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
//   final void Function(String type, int amount) onSelect;
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
//                 border: Border.all(color: AppColors.appYellowColour),
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
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget grid() {
//     final Data data = widget.details.data ?? Data();
//     final int videoDiscount = data.videoDiscountedAmount ?? 0;
//     final int videoOriginal = data.videoCallAmount ?? 0;
//     final int audioDiscount = data.audioDiscountedAmount ?? 0;
//     final int audioOriginal = data.audioCallAmount ?? 0;
//     final int privateDiscount = data.anonymousDiscountedAmount ?? 0;
//     final int privateOriginal = data.anonymousCallAmount ?? 0;
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
//             const Divider(),
//             listTile(
//               asset: "assets/images/live_call_video.png",
//               type: "Video",
//               discountAmount: videoDiscount,
//               originalAmount: videoOriginal,
//               subtitle: "Both consultant and you on video call",
//               buttonText: "Join",
//             ),
//             const Divider(),
//             listTile(
//               asset: "assets/images/live_call_audio.png",
//               type: "Audio",
//               discountAmount: audioDiscount,
//               originalAmount: audioOriginal,
//               subtitle: "Consultant on video and you on audio",
//               buttonText: "Join",
//             ),
//             const Divider(),
//             listTile(
//               asset: "assets/images/live_call_private.png",
//               type: "Private",
//               discountAmount: privateDiscount,
//               originalAmount: privateOriginal,
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
//     required int discountAmount,
//     required int originalAmount,
//     required String subtitle,
//     required String buttonText,
//   }) {
//     return ListTile(
//       dense: true,
//       contentPadding: EdgeInsets.zero,
//       leading: Image.asset(asset),
//       title: textWidget(
//         type: type,
//         discountAmount: discountAmount,
//         originalAmount: originalAmount,
//       ),
//       subtitle: Text(subtitle),
//       trailing: ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(
//             AppColors.appYellowColour,
//           ),
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(50.0)),
//             ),
//           ),
//         ),
//         onPressed: () {
//           widget.onSelect(
//             type,
//             discountAmount == 0 ? originalAmount : discountAmount,
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
//     required int discountAmount,
//     required int originalAmount,
//   }) {
//     return (discountAmount == 0)
//         ? Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 2,
//                 child: Text("$type Call @ ₹$originalAmount/Min"),
//               ),
//             ],
//           )
//         : Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 3,
//                 child: Text(
//                   "$type Call @ ₹$discountAmount/Min",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 4.0),
//               Expanded(
//                 child: Text(
//                   "₹$originalAmount/Min",
//                   style: const TextStyle(
//                     fontSize: 10,
//                     decoration: TextDecoration.lineThrough,
//                     decorationColor: Colors.red,
//                   ),
//                 ),
//               ),
//             ],
//           );
//   }
// }
