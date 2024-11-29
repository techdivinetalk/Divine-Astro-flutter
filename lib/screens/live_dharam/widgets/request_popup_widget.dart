// import "dart:convert";
// import "dart:ui";

// import "package:divine_astrologer/common/colors.dart";
// import "package:divine_astrologer/model/astrologer_profile/astrologer_gift_response.dart";
// import "package:divine_astrologer/model/live/get_astrologer_details_response.dart";
// import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
// import "package:flutter/material.dart";
// import "package:get/get.dart";

// class RequestPopupWidget extends StatefulWidget {
//   const RequestPopupWidget({
//     required this.onClose,
//     required this.details,
//     required this.speciality,
//     required this.type,
//     required this.onTapAcceptForGifts,
//     required this.onTapAcceptForVideoCall,
//     required this.onTapAcceptForAudioCall,
//     required this.onTapAcceptForPrivateCall,
//     required this.giftData,
//     required this.giftCount,
//     super.key,
//   });

//   final void Function() onClose;
//   final GetAstroDetailsRes details;
//   final String speciality;
//   final String type;
//   final void Function() onTapAcceptForGifts;
//   final void Function() onTapAcceptForVideoCall;
//   final void Function() onTapAcceptForAudioCall;
//   final void Function() onTapAcceptForPrivateCall;
//   final GiftData giftData;
//   final num giftCount;

//   @override
//   State<RequestPopupWidget> createState() => _RequestPopupWidgetState();
// }

// class _RequestPopupWidgetState extends State<RequestPopupWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: appColors.transparent,
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[top(), const SizedBox(height: 16), bottom()],
//         ),
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
//           child: const Icon(Icons.close, color: appColors.white),
//         ),
//       ),
//     );
//   }

//   Widget bottom() {
//     return ClipRRect(
//       borderRadius: const BorderRadius.all(Radius.circular(25.0)),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//         child: Container(
//           // height: Get.height / 2.24,
//           width: Get.width,
//           margin: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(25.0)),
//             border: Border.all(color: appColors.yellow),
//             color: appColors.white,
//           ),
//           child: grid(),
//         ),
//       ),
//     );
//   }

//   Widget grid() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           SizedBox(
//             height: 100,
//             width: 100,
//             child: CustomImageWidget(
//               imageUrl: widget.details.data?.image ?? "",
//               rounded: true,
//               typeEnum: TypeEnum.user,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             widget.details.data?.name ?? "",
//             style: const TextStyle(
//               fontSize: 24,
//               color: appColors.yellow,
//             ),
//           ),
//           const SizedBox(height: 0),
//           Text(
//             "Requested for ${requestedString()}",
//             style: const TextStyle(
//               fontSize: 20,
//               color: appColors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("Specialty"),
//               Text(widget.speciality),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("Language Proficiency"),
//               Text(languageString()),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("Experience"),
//               Text("${widget.details.data?.experiance ?? 0} years"),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("Amount"),
//               Text(amountString()),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text("Astrologer Rating"),
//               Text("${widget.details.data?.rating ?? 0}"),
//             ],
//           ),
//           const SizedBox(height: 16),
//           button(),
//         ],
//       ),
//     );
//   }

//   Widget button() {
//     final String type = widget.type;
//     if (type == "Ask For Gift") {
//       return moreOptionsButton(
//         buttonText: "Send Gift",
//         buttonCallback: widget.onTapAcceptForGifts,
//         buttonImage: "assets/images/live_new_gift_latest.png",
//       );
//     } else if (type == "Ask For Video Call") {
//       return moreOptionsButton(
//         buttonText: "Start Video Call",
//         buttonCallback: widget.onTapAcceptForVideoCall,
//         buttonImage: "assets/images/live_call_video.png",
//       );
//     } else if (type == "Ask For Voice Call") {
//       return moreOptionsButton(
//         buttonText: "Start Voice Call",
//         buttonCallback: widget.onTapAcceptForAudioCall,
//         buttonImage: "assets/images/live_call_audio.png",
//       );
//     } else if (type == "Ask For Private Call") {
//       return moreOptionsButton(
//         buttonText: "Start Private Call",
//         buttonCallback: widget.onTapAcceptForPrivateCall,
//         buttonImage: "assets/images/live_call_private.png",
//       );
//     } else {
//       return const SizedBox();
//     }
//   }

//   String requestedString() {
//     final String type = widget.type;
//     if (type == "Ask For Gift") {
//       return "${widget.giftCount}X ${widget.giftData.giftName}";
//     } else if (type == "Ask For Video Call") {
//       return "Video Call";
//     } else if (type == "Ask For Voice Call") {
//       return "Voice Call";
//     } else if (type == "Ask For Private Call") {
//       return "Private Call";
//     } else {
//       return "";
//     }
//   }

//   String amountString() {
//     final String type = widget.type;
//     final Data data = widget.details.data ?? Data();
//     final int videoDiscount = data.videoDiscountedAmount ?? 0;
//     final int videoOriginal = data.videoCallAmount ?? 0;
//     final int audioDiscount = data.audioDiscountedAmount ?? 0;
//     final int audioOriginal = data.audioCallAmount ?? 0;
//     final int privateDiscount = data.anonymousDiscountedAmount ?? 0;
//     final int privateOriginal = data.anonymousCallAmount ?? 0;
//     if (type == "Ask For Gift") {
//       return "₹${widget.giftCount * widget.giftData.giftPrice}";
//     } else if (type == "Ask For Video Call") {
//       return videoDiscount == 0 ? "₹$videoOriginal/Min" : "₹$videoDiscount/Min";
//     } else if (type == "Ask For Voice Call") {
//       return audioDiscount == 0 ? "₹$audioOriginal/Min" : "₹$audioDiscount/Min";
//     } else if (type == "Ask For Private Call") {
//       return privateDiscount == 0
//           ? "₹$privateOriginal/Min"
//           : "₹$privateDiscount/Min";
//     } else {
//       return "";
//     }
//   }

//   String languageString() {
//     final String inputString = widget.details.data?.language ?? "";
//     if (inputString.isEmpty) {
//       return "";
//     } else {
//       final List<dynamic> languageList = jsonDecode(inputString);
//       final String commaSeparatedString = languageList.join(', ');
//       return commaSeparatedString;
//     }
//   }

//   Widget moreOptionsButton({
//     required String buttonText,
//     required Function() buttonCallback,
//     required String buttonImage,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: SizedBox(
//         height: 60,
//         width: double.infinity,
//         child: ElevatedButton(
//           style: ButtonStyle(
//             elevation: MaterialStateProperty.all(4),
//             backgroundColor: MaterialStateProperty.all(appColors.yellow),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//               const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               ),
//             ),
//           ),
//           onPressed: buttonCallback,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 buttonImage,
//                 height: 24,
//                 width: 24,
//               ),
//               const SizedBox(width: 16),
//               Text(
//                 buttonText,
//                 style: const TextStyle(color: appColors.black),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
