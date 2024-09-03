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
import '../../model/categories_list.dart';
import '../../model/res_login.dart';
import '../../repository/user_repository.dart';
import '../../screens/live_page/constant.dart';

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
  final state = EditStttate();

  bool isAgrementSigned = false;
  Future<String>? pdfPath;
  bool isLastPage = false;

  UserRepository userRepository = UserRepository();
  UserData? userData;
  var preference = Get.find<SharedPreferenceService>();
  RxInt tag = (-0).obs;
  RxList<int> tagIndexes = <int>[].obs;
  RxList<String> skills = <String>[].obs;

  RxList<CategoriesData> tags = <CategoriesData>[].obs;
  List<CategoriesData> options = <CategoriesData>[].obs;

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
  List astroImages = [];
  updatePage(page) {
    currentPage = page;
    update();
  }

  List userImages2 = [];
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
    print("-----user Data --- ${userData!.toJson()}");
    if (userData!.name != null) {
      nameController.text = userData!.name ?? "";
    }
    if (userData!.experiance != null) {
      experiencesController.text = userData!.experiance ?? "";
    }

    if (userData != null) {
      userData?.astroCatPivot?.asMap().entries.forEach((element) {
        tagIndexes.add(element.key);
        tags.add(CategoriesData.fromAstrologerSpeciality(element.value));
      });
    }
    options = reorderList(tags);
  }

  late CategoriesList categoriesList;

  List<CategoriesData> reorderList(
    List<CategoriesData> selectedItems,
  ) {
    String specialityString = preferenceService.getSpecialAbility()!;

    categoriesList = categoriesDataFromJson(specialityString);

    // Create a copy of the original list
    List<CategoriesData> resultList = List.from(categoriesList.data);

    // Remove the selected items from the copy
    for (CategoriesData item in selectedItems) {
      resultList.removeWhere(
        (element) => element.id == item.id,
      );
    }

    // Insert the selected items at the beginning of the list
    resultList.insertAll(0, selectedItems);

    return resultList;
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
  List<dynamic> newList = [];
  List<dynamic> uploadedAstroImages = [];
  var selectedUploadedAstroImage;
  void checkSelectedImages() async {
    int selectedCount = userImages.where((element) => element is File).length;
    bool containsFile = userImages.any((element) => element is File);
    // Count the number of File objects in the userImages list
    int fileCount = userImages.where((element) => element is File).length;

    // Create a new list with the same number of values
    newList =
        List.filled(fileCount, null); // You can customize the default value

    if (containsFile == false) {
      Fluttertoast.showToast(msg: "Astrologer must select 2 or more images.");
    } else {
      if (uploadedImages.isEmpty) {
        if (selectedCount >= 2) {
          List<Future<void>> uploadTasks = [];
          for (int i = 0; i < userImages.length; i++) {
            if (userImages[i] is File) {
              uploadTasks.add(uploadImage(userImages[i], "astroimages"));
            }
          }

          Future.delayed(Duration(seconds: 2)).then((c) {
            if (newList.length == uploadedImages.length &&
                uploadedImages.contains(selectedUploadedAstroImage)) {
              print("222");
              submitStage3();
            }
          });
          print("User has selected and uploaded 2 or more images.");
        } else {
          Fluttertoast.showToast(
              msg: "Astrologer must select 2 or more images.");
        }
      } else {
        submitStage3();
      }
    }
  }
  // void checkSelectedImages() async {
  //   int selectedCount = userImages.where((element) => element is File).length;
  //   bool containsFile = userImages.any((element) => element is File);
  //
  //   if (!containsFile) {
  //     Fluttertoast.showToast(msg: "Astrologer must select 2 or more images.");
  //   } else {
  //     if (selectedCount >= 2) {
  //       // Upload images first
  //       for (int i = 0; i < userImages.length; i++) {
  //         // Check if the current item is a File before uploading
  //         if (userImages[i] is File) {
  //           await uploadImage(userImages[i], "astroimages");
  //         }
  //       }
  //       // After uploading all images, check if at least 2 were successfully uploaded
  //       if (uploadedImages.length >= 2) {
  //         // Submit the form with all successfully uploaded images
  //         submitStage3();
  //         print(
  //             "User has selected and uploaded $uploadedImages.length images.");
  //       } else {
  //         Fluttertoast.showToast(msg: "Failed to upload 2 or more images.");
  //       }
  //       print("User has selected and uploaded 2 or more images.");
  //     } else {
  //       Fluttertoast.showToast(msg: "Astrologer must select 2 or more images.");
  //     }
  //   }
  // }

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

            userImages[selected] = File(result.path.toString());
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

  // Future<void> uploadImage(imageFile, imageType) async {
  //   var token = await preferenceService.getToken();
  //
  //   print("image length - ${imageFile.path}");
  //   updateLoading(imageType, true);
  //   var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");
  //
  //   var request = http.MultipartRequest('POST', uri);
  //   request.headers.addAll({
  //     'Authorization': 'Bearer $token',
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //   });
  //
  //   // Attach the image file to the request
  //   request.files.add(await http.MultipartFile.fromPath(
  //     'image',
  //     imageFile.path,
  //   ));
  //   request.fields.addAll({"module_name": "onBoarding"});
  //
  //   var response = await request.send();
  //
  //   // Listen for the response
  //
  //   print("responseresponseresponse");
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     if (response.statusCode == 200) {
  //       print("Image uploaded successfully.");
  //       var imageUrl = jsonDecode(value)["data"]["full_path"];
  //
  //       if (jsonDecode(value)["data"]["full_path"] == null) {
  //         Fluttertoast.showToast(msg: "Not able to upload");
  //       } else {
  //         // Update the corresponding URL variable based on the image type
  //
  //         switch (imageType) {
  //           case 'profile':
  //             photoUrlprofile = imageUrl;
  //             break;
  //           case 'af':
  //             print(imageType);
  //             photoUrlAadharFront = imageUrl;
  //             break;
  //           case 'ab':
  //             print(imageType);
  //
  //             photoUrlAadharBack = imageUrl;
  //             break;
  //           case 'panFront':
  //             print(imageType);
  //
  //             photoUrlPanFront = imageUrl;
  //             break;
  //           case 'astroimages':
  //             print("image - 2");
  //
  //             uploadedImages.add(imageUrl);
  //
  //             print(uploadedImages.toString());
  //             break;
  //         }
  //       }
  //       updateLoading(imageType, false);
  //
  //       // if (image.isNotEmpty) {
  //       //   poojaImageUrl = image;
  //       // }
  //     } else {
  //       print("Failed to upload image.");
  //     }
  //   });
  // }
  Future<void> uploadImage(imageFile, imageType) async {
    var token = await preferenceService.getToken();

    print("Uploading image: ${imageFile.path}");
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

    try {
      var response = await request.send();

      // Handle the response
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("Image uploaded successfully.");
        var jsonResponse = jsonDecode(responseBody);
        var imageUrl = jsonResponse["data"]["full_path"];

        if (imageUrl == null) {
          Fluttertoast.showToast(msg: "Not able to upload");
        } else {
          // Update the corresponding URL variable based on the image type
          switch (imageType) {
            case 'profile':
              photoUrlprofile = imageUrl;
              break;
            case 'af':
              photoUrlAadharFront = imageUrl;
              break;
            case 'ab':
              photoUrlAadharBack = imageUrl;
              break;
            case 'panFront':
              photoUrlPanFront = imageUrl;
              break;
            case 'astroimages':
              selectedUploadedAstroImage = imageUrl;
              uploadedImages.add(imageUrl);
              break;
          }
        }
      } else {
        print("Failed to upload image.");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  OnBoardingStageModel? onBoardingStageModel1;
  OnBoardingStageModel? onBoardingStageModel2;
  OnBoardingStageModel? onBoardingStageModel3;
  OnBoardingStageModel? onBoardingStageModel4;

  RxBool stage1Submitting = false.obs;
  submitStage1() async {
    stage1Submitting.value = true;
    var body = {
      "name": nameController.text,
      "skills": skills,
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
        stage1Submitting.value = false;
        onBoardingStageModel1 = response;
        divineSnackBar(
            data: onBoardingStageModel1!.message.toString(),
            color: appColors.green);

        Get.offNamed(
          RouteName.onBoardingScreen2,
        );

        update();
      } else {
        divineSnackBar(
            data: onBoardingStageModel1!.message.toString(),
            color: appColors.redColor);
      }
    } catch (error) {
      stage1Submitting.value = false;

      // debugPrint("error $error");
      // if (error is AppException) {
      //   error.onException();
      // } else {
      //   // divineSnackBar(data: error.toString(), color: appColors.redColor);
      // }
    }
  }

  RxBool stage2Submitting = false.obs;

  submitStage2() async {
    stage2Submitting.value = true;
    var body = {
      "aadhar_front": photoUrlAadharFront,
      "aadhar_back": photoUrlAadharBack,
      "pancard": photoUrlPanFront,
      "page": 2,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage2Submitting.value = false;
        onBoardingStageModel2 = response;
        divineSnackBar(
            data: onBoardingStageModel2!.message.toString(),
            color: appColors.green);

        Get.offNamed(
          RouteName.onBoardingScreen3,
        );
        update();
      }
    } catch (error) {
      stage2Submitting.value = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  RxBool stage3Submitting = false.obs;

  submitStage3() async {
    stage3Submitting.value = true;
    var body = {
      "astro_images": uploadedImages,
      "page": 3,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage3Submitting.value = false;
        onBoardingStageModel3 = response;
        Get.offNamed(
          RouteName.onBoardingScreen4,
        );
        update();
      }
    } catch (error) {
      stage3Submitting.value = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  RxBool stage4Submitting = false.obs;

  submitStage4() async {
    stage4Submitting.value = true;
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
        stage4Submitting.value = false;
        update();
      }
    } catch (error) {
      stage4Submitting.value = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.redColor);
      }
    }
  }

  // submittingDetails() {
  //   if (userImages.contains(1) ||
  //       userImages.contains(2) ||
  //       userImages.contains(3) ||
  //       userImages.contains(4) ||
  //       userImages.contains(5)) {
  //     userImages.remove(1);
  //     userImages.remove(2);
  //     userImages.remove(3);
  //     userImages.remove(4);
  //     userImages.remove(5);
  //   } else {}
  //   var jsonData = {
  //     "name": nameController.text,
  //     "skills": skills,
  //     "experience": experiencesController.text,
  //     "dob": birthController.text,
  //     "location": locationController.text,
  //     "alternate_no": alterNoController.text,
  //     "profile_picture": photoUrlprofile,
  //     "aadhar_front": photoUrlAadharFront,
  //     "aadhar_back": photoUrlAadharBack,
  //     "pancard": selectedPanFront,
  //     "astro_images": uploadedImages,
  //   };
  //
  //   print(
  //       "${jsonData.toString().length >= 150 ? "${jsonData.toString()}\n" : jsonData.toString()}");
  // }

  void navigateToStage() {
    for (int stage in onBoardingList) {
      print(onBoardingList.toString());
      // Navigate to the screen based on the stage number
      switch (stage) {
        case 1:
          if (onBoardingList.length == 1) {
          } else {
            onBoardingList.remove(1);
          }
          Get.toNamed(
            RouteName.onBoardingScreen,
          );
          break;
        case 2:
          if (onBoardingList.length == 1) {
          } else {
            onBoardingList.remove(2);
          }
          // Navigate to the screen for stage 2
          Get.toNamed(
            RouteName.onBoardingScreen2,
          );
          break;
        case 3:
          if (onBoardingList.length == 1) {
          } else {
            onBoardingList.remove(3);
          }
          // Navigate to the screen for stage 3
          Get.toNamed(
            RouteName.onBoardingScreen3,
          );
          break;
        case 4:
          if (onBoardingList.length == 1) {
          } else {
            onBoardingList.remove(4);
          }
          // Navigate to the screen for stage 4
          Get.toNamed(
            RouteName.onBoardingScreen4,
          );
          break;
        case 5:
          if (onBoardingList.length == 1) {
          } else {
            onBoardingList.remove(5);
          }
          // Navigate to the screen for stage 5

          Get.toNamed(
            RouteName.onBoardingScreen5,
          );
          break;
        default:

          // Handle unexpected stage numbers
          print('Unknown stage number: $stage');
          break;
      }
    }
  }
}

class EditStttate {
  late CategoriesList categoriesList;
  void init() {
    String specialityString = preferenceService.getSpecialAbility()!;

    categoriesList = categoriesDataFromJson(specialityString);
  }
}
