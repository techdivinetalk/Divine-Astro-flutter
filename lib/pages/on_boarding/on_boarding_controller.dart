import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/permission_handler.dart';
import '../../common/routes.dart';
import '../../di/api_provider.dart';
import '../../di/shared_preference_service.dart';
import '../../model/OnBoardingStageModel.dart';
import '../../model/res_login.dart';
import '../../repository/user_repository.dart';

class FileUtils {
  static String getfilesizestring({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 bytes";
    const suffixes = [" bytes", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  static bool isFileSizeValid({required int bytes, int maxSizeInMB = 2}) {
    double sizeInMB = bytes / (1024 * 1024);
    print("image size ------ ${sizeInMB.toString()}");

    return sizeInMB <= maxSizeInMB;
  }
}

class OnBoardingController extends GetxController {
  UserRepository userRepository = UserRepository();
  UserData? userData;
  var preference = Get.find<SharedPreferenceService>();

  late TextEditingController nameController;
  late TextEditingController skillsController;
  late TextEditingController experiencesController;
  late TextEditingController birthController;
  late TextEditingController locationController;
  late TextEditingController alterNoController;

  FocusNode nameNode = FocusNode();
  FocusNode skillsNode = FocusNode();
  FocusNode experiencesNode = FocusNode();
  FocusNode birthNode = FocusNode();
  FocusNode locationNode = FocusNode();
  FocusNode alterNoNode = FocusNode();

  var currentPage = 1;
  var donePage = 1;
  List skills = ["dfdfd", "fdfd"];
  List astroImages = [];
  updatePage(page) {
    currentPage = page;
    update();
  }

  List userImages2 = [1, 2, 3, 4, 5];
  List userImages = [1, 2, 3, 4, 5];

  updateDonePage(page) {
    donePage = page;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    nameController = TextEditingController();
    skillsController = TextEditingController();
    experiencesController = TextEditingController();
    birthController = TextEditingController();
    locationController = TextEditingController();
    alterNoController = TextEditingController();
    userData = preference.getUserDetail();
    if (userData!.name != null) {
      nameController.text = userData!.name ?? "";
    }
  }

  // void checkSelectedImages() {
  //   print("image - 1");
  //   int selectedCount = userImages.where((element) => element is File).length;
  //   if (uploadedImages.isNotEmpty) {
  //     Get.toNamed(
  //       RouteName.onBoardingScreen4,
  //     );
  //   } else {
  //     if (selectedCount >= 2) {
  //       print("image - 1");
  //
  //       for (int i = 0; i < 5; i++) {
  //         print("image - 1");
  //
  //         print("Loop iteration: $i");
  //         if (userImages[i] == 1 ||
  //             userImages[i] == 2 ||
  //             userImages[i] == 3 ||
  //             userImages[i] == 4 ||
  //             userImages[i] == 5) {
  //           print("image - 1");
  //         } else {
  //           print("image - 2");
  //
  //           uploadImage(userImages[i], "astroimages");
  //         }
  //       }
  //       submitStage3();
  //       print("User has selected 2 or more images.");
  //       // You can proceed with your logic here
  //       // For example, enabling a submit button or showing a message
  //     } else {
  //       Fluttertoast.showToast(msg: "Please select more then 2 images");
  //       print("User has not selected enough images.");
  //       // Handle the case where less than 2 images are selected
  //     }
  //   }
  // }

  void checkSelectedImages() {
    int selectedCount = userImages.where((element) => element is File).length;
    if (uploadedImages.isEmpty) {
      if (selectedCount >= 2) {
        for (int i = 0; i < userImages.length; i++) {
          // Check if the current item is a File before uploading
          if (userImages[i] is File) {
            uploadImage(userImages[i], "astroimages");
          }
        }

        print("User has selected 2 or more images.");
      }
    } else {
      submitStage3();
    }
  }

  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;

  var selectedProfile;
  var selectedAadharFront;
  var selectedAadharBack;
  var selectedPanFront;

  bool loadingProfile = false;
  bool loadingAadharFront = false;
  bool loadingAadharBack = false;
  bool loadingPanFront = false;

  var photoUrlprofile;
  var photoUrlAadharFront;
  var photoUrlAadharBack;
  var photoUrlPanFront;
  List uploadedImages = [];

  /// Get Image Picker method
  Future getImage(selected) async {
    if (await PermissionHelper().askMediaPermission()) {
      XFile? pickedFiles;
      pickedFiles = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFiles != null) {
        await compressImages(XFile(pickedFiles.path), selected);
      }
      update();
    }
  }

  compressImages(croppedFile, selected) async {
    uploadFile = File(croppedFile.path);
    final filePath = uploadFile!.absolute.path;
    final lastIndex = filePath
        .lastIndexOf(RegExp(r'\.(png|jpg|jpeg|heic)', caseSensitive: false));

    debugPrint("File path: $filePath");
    debugPrint("Last index of extension: $lastIndex");

    if (lastIndex != -1) {
      final splitted = filePath.substring(0, lastIndex);
      final extension = filePath.substring(lastIndex).toLowerCase();

      // Ensure the output path ends with .jpg or .jpeg for compression
      String outPath;
      if (extension == '.heic' || extension == '.png') {
        outPath = "${splitted}_out.jpg";
      } else if (extension == '.jpg' || extension == '.jpeg') {
        outPath = "${splitted}_out$extension";
      } else {
        Fluttertoast.showToast(msg: "Unsupported file format.");
        return;
      }

      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 500,
      );

      if (result != null) {
        int imageSize =
            await File(result.path).length(); // Get the image size in bytes

        if (!FileUtils.isFileSizeValid(bytes: imageSize, maxSizeInMB: 5)) {
          // Fluttertoast.showToast(msg: "Image Size is more than 2 MB");
          Fluttertoast.showToast(msg: "Image Size should be less then 5 MB");
        } else {
          if (selected == "af") {
            uploadImage(File(result.path.toString()), selected);
            Fluttertoast.showToast(msg: "Image uploaded");

            selectedAadharFront = File(result.path);
          } else if (selected == "ab") {
            uploadImage(File(result.path.toString()), selected);
            Fluttertoast.showToast(msg: "Image uploaded");

            selectedAadharBack = File(result.path);
          } else if (selected == "panFront") {
            uploadImage(File(result.path.toString()), selected);
            Fluttertoast.showToast(msg: "Image uploaded");

            selectedPanFront = File(result.path);
          } else if (selected == "profile") {
            selectedProfile = File(result.path.toString());
            uploadImage(File(result.path.toString()), selected);
            Fluttertoast.showToast(msg: "Image uploaded");
          } else {
            print("----image---- ${userImages.toString()}");

            userImages[selected] = File(result.path
                .toString()); // Update the value with the selected image
            // uploadImage(userImages, "astroimages");
            print("----image---- ${userImages.toString()}");
          }
          // selected = File(result.path);
        }
        update();
      } else {
        debugPrint("Failed to compress the image.");
      }
    } else {
      Fluttertoast.showToast(
          msg: "The file path does not contain a valid extension.");
    }
  }

  updateLoading(imageType, value) {
    switch (imageType) {
      case 'Profile':
        loadingProfile = value;
        break;
      case 'af':
        loadingAadharFront = value;
        break;
      case 'ab':
        loadingAadharFront = value;
        break;
      case 'panFront':
        loadingAadharFront = value;
        break;
    }
    update();
  }

  Future<void> uploadImage(imageFile, imageType) async {
    var token = await preferenceService.getToken();

    print("image length - ${imageFile.path}");
    updateLoading(imageType, true);
    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    // Attach the image file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    request.fields.addAll({"module_name": "onBoarding"});

    var response = await request.send();

    // Listen for the response

    print("responseresponseresponse");
    response.stream.transform(utf8.decoder).listen((value) {
      if (response.statusCode == 200) {
        print("Image uploaded successfully.");
        var imageUrl = jsonDecode(value)["data"]["full_path"];

        if (jsonDecode(value)["data"]["full_path"] == null) {
          loadingAadharFront = false;

          Fluttertoast.showToast(msg: "Not able to upload");
        } else {
          // Update the corresponding URL variable based on the image type

          switch (imageType) {
            case 'profile':
              photoUrlprofile = imageUrl;
              break;
            case 'af':
              print(imageType);
              photoUrlAadharFront = imageUrl;
              break;
            case 'ab':
              print(imageType);

              photoUrlAadharBack = imageUrl;
              break;
            case 'panFront':
              print(imageType);

              photoUrlPanFront = imageUrl;
              break;
            case 'astroimages':
              print("image - 2");
              uploadedImages.add(imageUrl);

              print(uploadedImages.toString());
              break;
          }
        }
        updateLoading(imageType, false);

        // if (image.isNotEmpty) {
        //   poojaImageUrl = image;
        // }
      } else {
        print("Failed to upload image.");
      }
    });
  }

  OnBoardingStageModel? onBoardingStageModel1;
  OnBoardingStageModel? onBoardingStageModel2;
  OnBoardingStageModel? onBoardingStageModel3;
  OnBoardingStageModel? onBoardingStageModel4;

  bool stage1Submitting = false;
  submitStage1() async {
    stage1Submitting = true;
    var body = {
      "name": nameController.text,
      "skills": ["dfdfd", "fdfdd"],
      "experience": experiencesController.text,
      "dob": birthController.text,
      "location": locationController.text,
      "alternate_no": alterNoController.text,
      "profile_picture": photoUrlprofile,
      "page": 1,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage1Submitting = false;
        onBoardingStageModel1 = response;
        divineSnackBar(
            data: onBoardingStageModel1!.message.toString(),
            color: appColors.redColor);

        Get.offNamed(
          RouteName.onBoardingScreen2,
        );

        update();
      }
    } catch (error) {
      stage1Submitting = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  bool stage2Submitting = false;

  submitStage2() async {
    stage2Submitting = true;
    var body = {
      "aadhar_front": photoUrlAadharFront,
      "aadhar_back": photoUrlAadharBack,
      "pancard": photoUrlPanFront,
      "page": 2,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage2Submitting = false;
        onBoardingStageModel2 = response;
        divineSnackBar(
            data: onBoardingStageModel2!.message.toString(),
            color: appColors.redColor);

        Get.offNamed(
          RouteName.onBoardingScreen3,
        );
        update();
      }
    } catch (error) {
      stage2Submitting = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  bool stage3Submitting = false;

  submitStage3() async {
    stage3Submitting = true;
    var body = {
      "astro_images": uploadedImages,
      "page": 3,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage3Submitting = false;
        onBoardingStageModel3 = response;
        Get.offNamed(
          RouteName.onBoardingScreen4,
        );
        update();
      }
    } catch (error) {
      stage3Submitting = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  bool stage4Submitting = false;

  submitStage4() async {
    stage4Submitting = true;
    var body = {
      "name": "Raj",
      "skills": ["Cards", "data"],
      "experience": "1 Years",
      "dob": "20-08-2001",
      "location": "Mumbai, Maharashtra",
      "alternate_no": "84393849384",
      "profile_picture": "link",
      "page": 1,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage4Submitting = false;
        update();
      }
    } catch (error) {
      stage4Submitting = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  submittingDetails() {
    if (userImages.contains(1) ||
        userImages.contains(2) ||
        userImages.contains(3) ||
        userImages.contains(4) ||
        userImages.contains(5)) {
      userImages.remove(1);
      userImages.remove(2);
      userImages.remove(3);
      userImages.remove(4);
      userImages.remove(5);
    } else {}
    var jsonData = {
      "name": nameController.text,
      "skills": skills,
      "experience": experiencesController.text,
      "dob": birthController.text,
      "location": locationController.text,
      "alternate_no": alterNoController.text,
      "profile_picture": photoUrlprofile,
      "aadhar_front": photoUrlAadharFront,
      "aadhar_back": photoUrlAadharBack,
      "pancard": selectedPanFront,
      "astro_images": uploadedImages,
    };

    print(
        "${jsonData.toString().length >= 150 ? "${jsonData.toString()}\n" : jsonData.toString()}");
  }
}
