import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisibleTarrotCard extends StatelessWidget {
  final NewChatController? controller;
  const VisibleTarrotCard({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
          visible:
          AppFirebaseService().orderData.value["card"] != null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(
                    14), // First container border radius
              ), // First container color
              child: !controller!.isCardVisible.value
                  ? Text(
                "${AppFirebaseService().orderData.value["customerName"]} is picking tarot cards...",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle15(
                  fontColor: appColors.white,
                ),
              )
                  : Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          FirebaseDatabase.instance
                              .ref(
                              "order/${AppFirebaseService().orderData.value["orderId"]}/card")
                              .remove();
                          controller?.isCardVisible.value =
                          false;
                        },
                        child: Icon(Icons.cancel,
                            color: appColors.white),
                      ),
                      const Text(
                        "Chosen cards",
                        style: TextStyle(
                            color: Color(0x00ffffff)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        controller
                            !.getListOfCardLength(context),
                            (index) => Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 4),
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              // Adjust the height as needed
                              decoration: BoxDecoration(
                                color:
                                const Color(0xFF212121),
                                borderRadius:
                                BorderRadius.circular(
                                    10), // Second container border radius
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(5.0),
                                child: Image.network(
                                  "${preferenceService.getAmazonUrl() ?? ""}/${controller!.getValueByPosition(index)}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    return Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        controller
                            !.getListOfCardLength(context),
                            (index) => Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 2),
                            child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  // Add this line for text alignment
                                  controller
                                      !.getKeyByPosition(index),
                                  style: TextStyle(
                                    color: appColors.white,
                                    fontSize:
                                    12, // Adjust the font size as needed
                                  ),
                                  softWrap: true,
                                  maxLines: 3,
                                  // Maximum lines allowed
                                  overflow: TextOverflow
                                      .ellipsis, // Optional: use ellipsis to indicate text overflow
                                )),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ));
    });
  }
}
