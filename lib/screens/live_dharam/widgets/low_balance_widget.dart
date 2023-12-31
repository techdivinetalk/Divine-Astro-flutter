// import "dart:ui";

// import "package:divine_app/common/colors.dart";
// import "package:divine_app/model/astrologer_profile/insufficient_bal_model.dart";
// import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
// import "package:flutter/material.dart";
// import "package:get/get.dart";

// class LowBalanceWidget extends StatefulWidget {
//   const LowBalanceWidget({
//     required this.onClose,
//     required this.balModel,
//     required this.callbackBalModelData,
//     super.key,
//   });

//   final void Function() onClose;
//   final InsufficientBalModel balModel;
//   final Function(Data) callbackBalModelData;

//   @override
//   State<LowBalanceWidget> createState() => _LowBalanceWidgetState();
// }

// class _LowBalanceWidgetState extends State<LowBalanceWidget> {
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
//           // height: Get.height / 1.50 + 16,
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
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: <Widget>[
//           const SizedBox(height: 32),
//           Image.asset("assets/images/live_new_wallet.png"),
//           const SizedBox(height: 16),
//           const Text("Low Balance!"),
//           const SizedBox(height: 16),
//           Text(
//             widget.balModel.message ?? "",
//             textAlign: TextAlign.center,
//           ),
//           DynamicHeightGridView(
//             shrinkWrap: true,
//             itemCount: widget.balModel.data?.length ?? 0,
//             crossAxisCount: 4,
//             builder: (BuildContext context, int index) {
//               final Data data = widget.balModel.data?[index] ?? Data();
//               final String recharge = (data.rechargeAmount ?? 0).toString();
//               final String percentage = (data.percentage ?? 0).toString();
//               final finalRA = "₹$recharge";
//               final finalPR = "₹$percentage% Extra";
//               return InkWell(
//                 onTap: () {
//                   widget.callbackBalModelData(data);
//                 },
//                 child: SizedBox(
//                   height: 75 + 8,
//                   child: Card(
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           height: 50,
//                           width: Get.width,
//                           decoration: BoxDecoration(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(10.0),
//                               topRight: Radius.circular(10.0),
//                             ),
//                             border: Border.all(
//                               color: AppColors.yellow,
//                             ),
//                             color: AppColors.white.withOpacity(0.2),
//                           ),
//                           child: Center(
//                             child: Text(
//                               finalRA,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 25,
//                           width: Get.width,
//                           decoration: BoxDecoration(
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(10.0),
//                               bottomRight: Radius.circular(10.0),
//                             ),
//                             border: Border.all(
//                               color: AppColors.yellow,
//                             ),
//                             color: AppColors.yellow,
//                           ),
//                           child: Center(
//                             child: Text(
//                               finalPR,
//                               style: const TextStyle(
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
