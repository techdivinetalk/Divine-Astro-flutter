// import "dart:ui";

// import "package:divine_app/common/colors.dart";
// import "package:flutter/material.dart";
// import "package:get/get.dart";

// class MoreOptionsWidget extends StatefulWidget {
//   const MoreOptionsWidget({
//     required this.onClose,
//     required this.isHost,
//     required this.onTapOnBlockUser,
//     required this.onTapOnReportUser,
//     required this.onTapOnRequestGift,
//     super.key,
//   });

//   final void Function() onClose;
//   final bool isHost;
//   final void Function() onTapOnBlockUser;
//   final void Function() onTapOnReportUser;
//   final void Function() onTapOnRequestGift;

//   @override
//   State<MoreOptionsWidget> createState() => _MoreOptionsWidgetState();
// }

// class _MoreOptionsWidgetState extends State<MoreOptionsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.transparent,
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
//             border: Border.all(color: AppColors.white),
//             color: AppColors.white.withOpacity(0.2),
//           ),
//           child: const Icon(Icons.close, color: AppColors.white),
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
//           // height: Get.height / 3.00,
//           width: Get.width,
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(50.0),
//               topRight: Radius.circular(50.0),
//             ),
//             border: Border.all(color: AppColors.yellow),
//             color: AppColors.white,
//           ),
//           child: grid(),
//         ),
//       ),
//     );
//   }

//   Widget grid() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         ListTile(
//           dense: true,
//           leading: const Icon(Icons.block),
//           title: const Text("Block User"),
//           onTap: widget.onTapOnBlockUser,
//         ),
//         const SizedBox(height: 16),
//         ListTile(
//           dense: true,
//           leading: const Icon(Icons.report),
//           title: const Text("Report User"),
//           onTap: widget.onTapOnReportUser,
//         ),
//         const SizedBox(height: 16),
//         if (widget.isHost)
//           ListTile(
//             dense: true,
//             leading: const Icon(Icons.card_giftcard),
//             title: const Text("Request Gift"),
//             onTap: widget.onTapOnRequestGift,
//           )
//         else
//           const SizedBox(),
//       ],
//     );
//   }
// }
