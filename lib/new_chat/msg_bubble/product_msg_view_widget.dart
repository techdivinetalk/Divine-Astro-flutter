
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../gen/assets.gen.dart';

class ProductMsgViewWidget extends StatefulWidget {
  final NewChatController? controller;
  final ChatMessage chatDetail;
  final bool yourMessage;
  ProductMsgViewWidget({required this.chatDetail, required this.yourMessage, this.controller});

  @override
  State<ProductMsgViewWidget> createState() => _ProductMsgViewWidgetState();
}

class _ProductMsgViewWidgetState extends State<ProductMsgViewWidget> {
  GetProduct getProduct = GetProduct();
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        // Map<String, dynamic> param = {};
        // param["is_recharge"] = "2";
        // param["product_type"] =
        // widget.chatDetail.msgType == MsgType.pooja ? "10" : "1";
        // param["product_id"] = widget.chatDetail.productId;
        // param["suggested_remedies_id"] = widget.chatDetail.suggestedId;
        // param["astrologer_id"] =
        //     AppFirebaseService().orderData.value["astroId"].toString();
        // Get.put(PaymentSummaryController()).initPayment(
        //     getProduct.productPriceInr.toString(), param, 0,
        //     gst: getProduct.gst ?? 0);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: appColors.white,
          boxShadow: [
            BoxShadow(
              color: appColors.textColor.withOpacity(0.4),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0.sp),
            child: CommonImageView(
              height: 50,
              width: 50,
              placeHolder: Assets.images.defaultProfile.path,
              imagePath:
              "${preferenceService.getAmazonUrl()}${getProduct.prodImage}",
            ),
          ),
          title: CustomText(
            "${widget.controller!.astrologerName.value} have suggested you a ${widget.chatDetail.msgType == MsgType.pooja ? "Pooja" : "product"}",
            fontSize: 14.sp,
            maxLines: 2,
            fontWeight: FontWeight.w600,
          ),
          subtitle: CustomText(
            getProduct.prodName ?? '',
            fontSize: 12.sp,
            maxLines: 20,
            fontWeight: FontWeight.w500,
          ),
          trailing: Container(
            height: 26,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: appColors.guideColor),
            child: Center(
              child: Text(
                "Book",
                style: AppTextStyle.textStyle12(
                  fontColor: appColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // onTap: () => Get.toNamed(RouteName.remediesDetail,
          //     arguments: {'title': temp[0], 'subtitle': temp[1]}),
        ),
      ),
    );
  }
}
