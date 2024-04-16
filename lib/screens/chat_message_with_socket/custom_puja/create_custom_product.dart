import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/common/SvgIconButton.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/repository/notice_repository.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/add_puja/add_puja_controller.dart';
import 'package:divine_astrologer/screens/chat_assistance/chat_message/chat_assistant_message_controller.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_controller.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_list_model.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/model/custom_product_model.dart';
import 'package:divine_astrologer/screens/puja/widget/remedy_text_filed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../gen/assets.gen.dart';
import '../../../model/chat_offline_model.dart';

class CreateCustomProductSheet extends StatefulWidget {
  final ChatMessageWithSocketController? controller;
  final ChatMessageController? chatMessageController;

  const CreateCustomProductSheet(
      {super.key, this.controller, this.chatMessageController});

  @override
  State<CreateCustomProductSheet> createState() =>
      _CreateCustomProductSheetState();
}

class _CreateCustomProductSheetState extends State<CreateCustomProductSheet> {
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 10,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              border: Border.all(color: appColors.white),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.clear_rounded,
              color: appColors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              InkWell(
                  onTap: () async {
                    if (await PermissionHelper().askMediaPermission()) {
                      updateProfileImage();
                    }
                  },
                  child: CommonImageView(
                    imagePath: productImageUrl.isEmpty
                        ? Assets.images.icUploadStory.path
                        : productImageUrl,
                    fit: BoxFit.cover,
                    height: 90.h,
                    width: 90.h,
                    placeHolder: Assets.images.defaultProfile.path,
                    radius: BorderRadius.circular(100.h),
                  )),
              SizedBox(height: 10.h),
              CustomText(
                'Upload Product Image',
                fontColor: appColors.textColor,
              ),
              SizedBox(height: 20.h),
              PoojaRemedyTextFiled(
                title: "Product Name",
                maxLength: 20,
                controller: productName,
                textInputFormatter: [CustomSpaceInputFormatter()],
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              PoojaRemedyTextFiled(
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(10),
                  CustomSpaceInputFormatter(),
                  FilteringTextInputFormatter.digitsOnly
                ],
                isSuffix: false,
                title: 'Product Price ( In INR )',
                controller: productPrice,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product Price is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  if (productApiPath.isEmpty) {
                    Fluttertoast.showToast(msg: "Please select product image");
                  } else if (productName.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter product name");
                  } else if (productPrice.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter product price");
                  } else {
                    addCustomProduct();
                  }
                  // if (formKey.currentState?.validate() ?? false) {}
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appColors.guideColor,
                  ),
                  child: CustomText(
                    'Save',
                    fontColor: appColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  updateProfileImage() {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (BuildContext context) {
        return Material(
          color: appColors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: appColors.white, width: 1.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      color: appColors.white.withOpacity(0.1)),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                  color: appColors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    CustomText(
                      'chooseOptions'.tr,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      'shareOptions'.tr,
                      fontSize: 16.sp,
                      fontColor: appColors.grey,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: () async {
                            Get.back();
                            await getImage(true);
                          },
                          child: Column(
                            children: [
                              Assets.svg.camera.svg(),
                              SizedBox(height: 8.h),
                              CustomText(
                                "camera".tr,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 64.w),
                        CustomButton(
                          onTap: () async {
                            Get.back();
                            await getImage(false);
                          },
                          child: Column(
                            children: [
                              Assets.svg.gallery.svg(),
                              SizedBox(height: 8.h),
                              CustomText(
                                "gallery".tr,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Get Image Picker method
  Future getImage(bool isCamera) async {
    pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 250,
    );

    if (pickedFile != null) {
      image = File(pickedFile!.path);

      await cropImage();
    }
  }

  /// Crop aimge method
  String productImageUrl = "";
  String productApiPath = "";

  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;

  cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Update image',
          toolbarColor: appColors.white,
          toolbarWidgetColor: appColors.blackColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Update image',
        ),
      ],
    );
    if (croppedFile != null) {
      // final file = File(croppedFile.path);

      uploadFile = File(croppedFile.path);
      final filePath = uploadFile!.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );
      if (result != null) {
        uploadImage(File(result.path));

        print(image);

        setState(() {});
        print("imageimageimageimage");
      }
    } else {
      debugPrint("Image is not cropped.");
    }
  }

  Future<void> uploadImage(File imageFile) async {
    var uri = Uri.parse(
        "https://wakanda-api.divinetalk.live/api/astro/v7/uploadImage");

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    request.fields.addAll({"module_name": "pooja"});

    var response = await request.send();

    // Listen for the response

    response.stream.transform(utf8.decoder).listen((value) {
      print(jsonDecode(value)["data"]);
      productApiPath = jsonDecode(value)["data"]["path"];
      productImageUrl = jsonDecode(value)["data"]["full_path"];
      setState(() {});
      print("valuevaluevaluevaluevaluevaluevalue");
    });

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");
      // if (image.isNotEmpty) {
      //   poojaImageUrl = image;
      // }
    } else {
      print("Failed to upload image.");
    }
  }

  CustomProductData? customProductData;
  final userRepository = UserRepository();

  addCustomProduct() async {
    try {
      Map<String, dynamic> body = {
        "prod_name": productName.text,
        "prod_image": productApiPath,
        "product_price": productPrice.text,
      };
      final response = await userRepository.customeEcommerceApi(body);

      if (response.data != null) {
        customProductData = response.data!;
        if (widget.controller != null) {
          widget.controller!.customProductData.add(customProductData!);
          final String time =
              "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
          widget.controller!.addNewMessage(
            time,
            MsgType.customProduct,
            messageText: productName.text,
            productPrice: productPrice.text,
            productId: customProductData!.id.toString(),
            awsUrl: productImageUrl,
            getCustomProduct: CustomProduct(
              id: customProductData!.id,
              name: productName.text,
              image: productApiPath,
              amount: int.parse(productPrice.text),
              desc: "",
            ),
          );
        } else if (widget.chatMessageController != null) {
          widget.chatMessageController!.sendMsg(MsgType.customProduct, {
            'title': productName.text,
            'image': productApiPath.toString(),
            'product_price': productPrice.text.toString(),
            'product_id': customProductData!.id.toString(),
          });
        }

        Get.back();
        setState(() {});
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
