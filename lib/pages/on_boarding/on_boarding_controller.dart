import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../common/app_exception.dart';
import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/permission_handler.dart';
import '../../common/routes.dart';
import '../../di/api_provider.dart';
import '../../di/shared_preference_service.dart';
import '../../model/GetAstroOnboarding.dart';
import '../../model/OnBoardingStageModel.dart';
import '../../model/categories_list.dart';
import '../../model/number_change_request_model/number_change_response_model.dart';
import '../../model/number_change_request_model/verify_otp_response.dart';
import '../../model/res_login.dart';
import '../../repository/user_repository.dart';
import '../../screens/live_page/constant.dart';
import '../../screens/otp_verification/timer_controller.dart';
import '../../screens/signature_module/model/agreement_model.dart';
import 'on_boarding_1.dart';

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
  ScrollController scrollController3 = ScrollController();
  var isAgrementSigned = false.obs;
  updateAgrementStatus(status) {
    print("printing status -- ${isAgrementSigned.value.toString()}");

    isAgrementSigned.value = status;
    print("printing status -- ${isAgrementSigned.value.toString()}");
    update();
  }

  UserRepository userRepository = UserRepository();
  UserData? userData;
  var preference = Get.find<SharedPreferenceService>();
  // RxInt tag = (-0).obs;
  // RxList<int> tagIndexes = <int>[].obs;
  // RxList<String> skills = <String>[].obs;
  //
  // RxList<CategoriesData> tags = <CategoriesData>[].obs;
  // List<CategoriesData> options = <CategoriesData>[].obs;
  // Observables
  RxInt tag = (-0).obs;
  RxList<int> tagIndexes = <int>[].obs;
  RxList<int> skills = <int>[].obs;
  RxList<CategoriesData> tags = <CategoriesData>[].obs;
  List<CategoriesData> options = <CategoriesData>[].obs;

  // Fetch user data and assign it to the form fields
  void _assignData() {
    userData = preference.getUserDetail();
    // Fetch the categories list
    String specialityString = preference.getSpecialAbility()!;
    print("categories data printing ---- ${specialityString.toString()}");
    categoriesList = categoriesDataFromJson(specialityString);
  }

  // Initialize the tag-related data
  void _initializeTags() {
    if (userData != null) {
      tagIndexes.clear();
      tags.clear();
      skills.clear();
      options.clear();
      userData?.astroCatPivot?.asMap().entries.forEach((element) {
        // tagIndexes.add(element.key);
        // tags.add(CategoriesData.fromAstrologerSpeciality(element.value));
        // skills.add(CategoriesData.fromAstrologerSpeciality(element.value).id!);
        //
        // // Join the 'name' fields of the Skill objects into a single string separated by commas
        // String s = tags.map((skill) => skill.name).join(', ');
        // skillsController.text = s;
      });
    }

    // Reorder the list based on tags
    options = reorderList(categoriesList.data, tags);
    print('Options loaded: ${options.map((e) => e.name)}');
  }

  late TextEditingController nameController;
  late TextEditingController skillsController;
  late TextEditingController experiencesController;
  late TextEditingController birthController;
  late TextEditingController locationController;
  late TextEditingController alterNoController;
  late TextEditingController otpController;
  late TextEditingController aadharController;
  late TextEditingController pancardController;

  FocusNode nameNode = FocusNode();
  FocusNode skillsNode = FocusNode();
  FocusNode experiencesNode = FocusNode();
  FocusNode aadharNode = FocusNode();
  FocusNode pancardNode = FocusNode();
  FocusNode birthNode = FocusNode();
  FocusNode locationNode = FocusNode();
  FocusNode alterNoNode = FocusNode();
  String number = "";
  String number2 = "";
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

  late CategoriesList categoriesList;
  var enableOrDisable = "0".obs;

  final DatabaseReference database = FirebaseDatabase.instance.ref();
  RxMap<String, dynamic> firebaseDDDD = <String, dynamic>{}.obs;

  getStatusFromFir() async {
    print("astrologer////////////////////////");

    database
        .child("astrologer/${userData!.id}/realTime")
        .onValue
        .listen((DatabaseEvent event) async {
      final DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = (dataSnapshot.value ??
              <dynamic, dynamic>{}) as Map<dynamic, dynamic>;

          // Assuming firebaseDDDD is a reactive variable
          firebaseDDDD.value = Map<String, dynamic>.from(map);

          // Check for verifyingOnboarding status
          if (firebaseDDDD.value["verifyingOnboarding"] != null) {
            print(
                "verifyingOnboarding--status -- ${firebaseDDDD.value["verifyingOnboarding"]}");

            String onboardingStatus =
                firebaseDDDD.value["verifyingOnboarding"].toString();

            // Update enableOrDisable with .value
            if (onboardingStatus == "0" || onboardingStatus == "1") {
              enableOrDisable.value =
                  onboardingStatus; // Correctly setting value for RxString
              update();
            }
          }
        }
      }
    });
  }

  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>["updateAgreement"],
  );

  var fetchAgaing = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    loadPreDefineData();
    getStatusFromFir();
    nameController = TextEditingController();
    skillsController = TextEditingController();
    experiencesController = TextEditingController();
    birthController = TextEditingController();
    locationController = TextEditingController();
    alterNoController = TextEditingController();
    otpController = TextEditingController();
    aadharController = TextEditingController();
    pancardController = TextEditingController();
    userData = preference.getUserDetail();
    print("-----user Data --- ${userData!.toJson()}");
    if (userData!.name != null) {
      nameController.text = userData!.name ?? "";
    }
    getAstrologerStatus();

    receiver.start().then((val) {
      receiver.messages.listen((event) {
        print("fetching Agreementttttttttt");
        if (event.name == "updateAgreement") {
          getAstrologerStatus();
        }
      });
    });

    fetchAutofiledData();
    if (userData!.experiance != null) {
      experiencesController.text = userData!.experiance ?? "";
    }

    print('User data: $userData');
    _assignData();
    _initializeTags();
    // if (userData != null) {
    //   userData?.astroCatPivot?.asMap().entries.forEach((element) {
    //     tagIndexes.add(element.key);
    //     tags.add(CategoriesData.fromAstrologerSpeciality(element.value));
    //     skills
    //         .add(CategoriesData.fromAstrologerSpeciality(element.value).name!);
    //
    //     // Join the 'name' fields of the Skill objects into a single string separated by commas
    //     String s = tags.map((skill) => skill.name).join(', ');
    //     skillsController.text = s;
    //   });
    // }
    //
    // // Reorder the list based on tags
    // options = reorderList(tags);
    // print('Options loaded: ${options.map((e) => e.name)}');
  }

  void loadPreDefineData() async {
    String specialityString = preference.getSpecialAbility()!;
    categoriesList = categoriesDataFromJson(specialityString);

    print("categories data printing ---- ${categoriesList.toJson()}");
  }

  // late CategoriesList categoriesList;
  //
  // List<CategoriesData> reorderList(
  //   List<CategoriesData> selectedItems,
  // ) {
  //   String specialityString = preferenceService.getSpecialAbility()!;
  //
  //   var categoriesList = categoriesDataFromJson(specialityString);
  //
  //   // Create a copy of the original list
  //   List<CategoriesData> resultList = List.from(categoriesList.data);
  //
  //   // Remove the selected items from the copy
  //   for (CategoriesData item in selectedItems) {
  //     resultList.removeWhere(
  //       (element) => element.id == item.id,
  //     );
  //   }
  //
  //   // Insert the selected items at the beginning of the list
  //   resultList.insertAll(0, selectedItems);
  //
  //   return resultList;
  // }
  // List<CategoriesData> reorderList(
  //   List<CategoriesData> originalList,
  //   List<CategoriesData> selectedItems,
  // ) {
  //   // Create a copy of the original list
  //   List<CategoriesData> resultList = List.from(originalList);
  //
  //   // Remove the selected items from the copy
  //   for (CategoriesData item in selectedItems) {
  //     resultList.removeWhere(
  //       (element) => element.id == item.id,
  //     );
  //   }
  //
  //   // Insert the selected items at the beginning of the list
  //   resultList.insertAll(0, selectedItems);
  //
  //   return resultList;
  // }

  // Reorder list based on selected items
  List<CategoriesData> reorderList(
    List<CategoriesData> originalList,
    List<CategoriesData> selectedItems,
  ) {
    List<CategoriesData> resultList = List.from(originalList);

    for (CategoriesData item in selectedItems) {
      resultList.removeWhere((element) => element.id == item.id);
    }

    resultList.insertAll(0, selectedItems);
    return resultList;
  }

  // List<dynamic> newList = [];
  // List<dynamic> uploadedAstroImages = [];
  // var selectedUploadedAstroImage;
  // void checkSelectedImages() async {
  //   print("111111");
  //   int selectedCount = userImages.where((element) => element is File).length;
  //   bool containsFile = userImages.any((element) => element is File);
  //   // Count the number of File objects in the userImages list
  //   int fileCount = userImages.where((element) => element is File).length;
  //
  //   // Create a new list with the same number of values
  //   newList =
  //       List.filled(fileCount, null); // You can customize the default value
  //
  //   if (containsFile == false) {
  //     print("111111");
  //     Fluttertoast.showToast(msg: "Astrologer must select 2 or more images.");
  //   } else {
  //     print("22222");
  //     if (uploadedImages.isEmpty) {
  //       print("22222");
  //
  //       if (selectedCount >= 2) {
  //         print("22222");
  //
  //         List<Future<void>> uploadTasks = [];
  //         for (int i = 0; i < userImages.length; i++) {
  //           if (userImages[i] is File) {
  //             print("333333");
  //
  //             uploadTasks.add(uploadImage(userImages[i], "astroimages"));
  //           }
  //         }
  //
  //         Future.delayed(Duration(seconds: 2)).then((c) {
  //           if (newList.length == uploadedImages.length &&
  //               uploadedImages.contains(selectedUploadedAstroImage)) {
  //             print("333333");
  //             update();
  //             submitStage3();
  //           }
  //         });
  //         print("User has selected and uploaded 2 or more images.");
  //       } else {
  //         Fluttertoast.showToast(
  //             msg: "Astrologer must select 2 or more images.");
  //       }
  //     } else {
  //       print("5555555");
  //
  //       submitStage3();
  //     }
  //   }
  // }
  List<dynamic> newList = [];
  List<dynamic> uploadedAstroImages = [];
  var selectedUploadedAstroImage;

  void checkSelectedImages() async {
    print("111111");
    int selectedCount = userImages.where((element) => element is File).length;
    bool containsFile = userImages.any((element) => element is File);

    // Count the number of File objects in the userImages list
    int fileCount = userImages.where((element) => element is File).length;

    // Create a new list with the same number of values
    newList =
        List.filled(fileCount, null); // You can customize the default value

    if (!containsFile) {
      print("111111");
      Fluttertoast.showToast(msg: "Astrologer must select 2 or more images.");
    } else {
      print("22222");

      if (uploadedImages.isEmpty) {
        print("22222");

        if (selectedCount >= 2) {
          print("22222");

          // Use a loop with await to ensure all uploads are finished
          for (int i = 0; i < userImages.length; i++) {
            if (userImages[i] is File) {
              print("Uploading image $i");
              await uploadImage(
                  userImages[i], "astroimages"); // Wait for each upload
            }
          }

          // Check if all images are uploaded and the condition is met
          if (newList.length == uploadedImages.length &&
              uploadedImages.contains(selectedUploadedAstroImage)) {
            print("All images uploaded, calling submitStage3");
            submitStage3();
          } else {
            print("Error: Some images were not uploaded.");
          }
        } else {
          Fluttertoast.showToast(
              msg: "Astrologer must select 2 or more images.");
        }
      } else {
        print("5555555");
        submitStage3(); // Images are already uploaded, just call submitStage3
      }
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

  var verifyAadharFront;
  var verifyAadharBack;
  var verifyPanFront;
  List uploadedImages = [];

  fetchAutofiledData() {
    // print("printing list ------ ${onBoardingList.toString()}");
    // print("printing list ------ ${onBoardingList.first.toString()}");
    if (onBoardingList.isNotEmpty) {
      getAutofill(onBoardingList.first);
    }
  }

  GetAstroOnboarding? getAstroOnboarding;
  GetAstroOnboarding? getAstroOnboarding2;
  GetAstroOnboarding? getAstroOnboarding3;
  List<String> astroImagess = [];
  String pancard = "";
  List demoImage = [];

  bool loadingTrainingssss = false;
  getAutofill(screen) async {
    loadingTrainingssss = true;
    var body = {
      "page": screen,
    };
    print(body.toString());
    var jsonData;
    try {
      final data = await userRepository.getOnBoardingApiFun(body);
      print(data.toString());
      if (data.success == true) {
        getAstroOnboarding = data;
        jsonData = getAstroOnboarding!.data?.data;
        demoImage = data.images == null ? [] : data.images!;
        // Parse the JSON string into a Map
        Map<String, dynamic> dataMap =
            jsonData == null ? {} : jsonDecode(jsonData);
        getAutoFillDataAssign(dataMap);
        loadingTrainingssss = false;
        update();
      } else {
        loadingTrainingssss = false;
      }

      update();
    } catch (error) {
      debugPrint("error::::: $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

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
            CroppedFile? croppedFile = await cropImage(File(result.path));
            if (croppedFile != null) {
              uploadImage(File(croppedFile.path.toString()), selected);

              selectedAadharFront = File(croppedFile.path);
            }
          } else if (selected == "ab") {
            CroppedFile? croppedFile = await cropImage(File(result.path));
            if (croppedFile != null) {
              uploadImage(File(croppedFile.path.toString()), selected);

              selectedAadharBack = File(croppedFile.path);
            }
          } else if (selected == "panFront") {
            CroppedFile? croppedFile = await cropImage(File(result.path));
            if (croppedFile != null) {
              uploadImage(File(croppedFile.path.toString()), selected);

              selectedPanFront = File(croppedFile.path);
            }
          } else if (selected == "profile") {
            // selectedProfile = File(result.path.toString());
            // uploadImage(File(result.path.toString()), selected);
            // Fluttertoast.showToast(msg: "Image uploaded");
            CroppedFile? croppedFile = await cropImage(File(result.path));
            if (croppedFile != null) {
              uploadImage(File(croppedFile.path.toString()), selected);

              selectedProfile = File(croppedFile.path);
            }
          } else {
            CroppedFile? croppedFile = await cropImage(File(result.path));
            if (croppedFile != null) {
              userImages[selected] = File(croppedFile.path.toString());
            }
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

  Future<CroppedFile?> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: appColors.white,
          toolbarWidgetColor: appColors.blackColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );
    return croppedFile;
  }
  // updateLoading(imageType, value) {
  //   switch (imageType) {
  //     case 'Profile':
  //       loadingProfile = value;
  //       break;
  //     case 'af':
  //       loadingAadharFront = value;
  //       break;
  //     case 'ab':
  //       loadingAadharFront = value;
  //       break;
  //     case 'panFront':
  //       loadingAadharFront = value;
  //       break;
  //   }
  //   update();
  // }

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
    var uri = Uri.parse("${ApiProvider.imageBaseUrl}uploadImage");
    print("------------${uri}");
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
        print("----------${imageUrl}");
        if (imageUrl == null) {
          Fluttertoast.showToast(msg: "Not able to upload");
        } else {
          // Update the corresponding URL variable based on the image type
          switch (imageType) {
            case 'profile':
              photoUrlprofile = imageUrl;
              Fluttertoast.showToast(msg: "Image uploaded");

              break;
            case 'af':
              photoUrlAadharFront = imageUrl;
              Fluttertoast.showToast(msg: "Image uploaded");

              break;
            case 'ab':
              photoUrlAadharBack = imageUrl;
              Fluttertoast.showToast(msg: "Image uploaded");

              break;
            case 'panFront':
              photoUrlPanFront = imageUrl;
              Fluttertoast.showToast(msg: "Image uploaded");

              break;
            case 'astroimages':
              selectedUploadedAstroImage = imageUrl;
              Fluttertoast.showToast(msg: "Image uploaded");

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

  late Timer timer;
  var start = 120.obs; // 2 minutes = 120 seconds

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        timer.cancel(); // Stop the timer
      } else {
        start.value--;
      }
      update();
    });
  }

  late NumberChangeResponse numberChangeResponse;
  var sentOtp = false.obs;
  var sending = false.obs;
  var show = false.obs;
  void sendOtpForNumberChange() async {
    sending.value = true;
    update();

    try {
      Map<String, dynamic> param = {
        "mobile_no": alterNoController.text.trim(),
      };
      final response = await userRepository.sendNumberChangeOtpAPI(param);
      if (response.success == true) {
        numberChangeResponse = response;
        sentOtp.value = true;
        sending.value = false;
        show.value = true;

        Fluttertoast.showToast(msg: numberChangeResponse.message ?? "");
        Get.bottomSheet(Padding(
          padding: EdgeInsets.only(),
          child: VerifyOtpSheet(
            onBoardingData: {
              "name": nameController.text,
              "skills": skills,
              "skills_name": skillsController.text,
              "experience": experiencesController.text,
              "dob": birthController.text,
              "location": locationController.text,
              "alternate_no": alternateMobile.value,
              "page": 1,
            },
          ),
        ));
        update();
        print("request to change mobile number");
      } else {
        Fluttertoast.showToast(msg: numberChangeResponse.message ?? "");
      }
    } catch (err) {
      sending.value = false;
      update();

      if (err is CustomException) {
        //err.onException();
        // showOtpSheet(
        //   context: Get.context!,
        //   message: err.message,
        // );
        Fluttertoast.showToast(msg: err.message ?? "");
      }
    }
  }

  final timerController = Get.put(TimerController());

  var isResendOtp = false.obs;
  var sessionId = "";

  resendOtp() async {
    Map<String, dynamic> params = {
      "mobile_no": alterNoController.text.toString()
    };
    try {
      isResendOtp.value = true;
      NumberChangeResponse data =
          await userRepository.sendNumberChangeOtpAPI(params);
      sessionId = data.data!.sessionId!;
      start = 120.obs;
      startTimer();

      isResendOtp.value = false;
      divineSnackBar(data: "OTP Re-send successfully.");
      update();
    } catch (error) {
      isResendOtp.value = false;
      update();
      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else if (error is OtpInvalidTimerException) {
        timerController.extractTimerValue(error.message);
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

  var isWrongOtp = false.obs;
  var attempts = 3.obs;

  removeAttempts() {
    if (attempts.value > 0) {
      attempts.value = attempts.value - 1;
    }
  }

  String? errorMessage;
  VerifyOtpResponse? verifyOtpResponse;
  var OtpVerified = false.obs;
  var verifying = false.obs;
  void verifyOtpForNumberChange(data) async {
    verifying.value = true;
    stage1Submitting.value = true;

    update();
    try {
      if (otpController.text.isEmpty || otpController.text.length != 6) return;
      Map<String, dynamic> param = {
        "mobile_no": alternateMobile.value.trim(),
        "otp": otpController.text.trim(),
        "onboarding": 1
      };
      final response = await userRepository.verifyOtpAPi(param);
      verifyOtpResponse = response;
      if (response.statusCode == 200 && response.success!) {
        divineSnackBar(data: "Verified");
        OtpVerified.value = true;
        verifying.value = false;
        isWrongOtp.value = false;
        stage1Submitting.value = false;
        update();
        submitStage1(data);
        errorMessage = null;
        number = alterNoController.text.trim();
        update();
      }
    } catch (err) {
      verifying.value = false;
      isWrongOtp.value = true;
      OtpVerified.value = false;
      stage1Submitting.value = false;

      removeAttempts();

      update();
      if (err is CustomException) {
        errorMessage = err.message;
        print(err.toString());
        Fluttertoast.showToast(msg: errorMessage!);
        update();
        //err.onException();
      }
    }
  }

  OnBoardingStageModel? onBoardingStageModel1;
  OnBoardingStageModel? onBoardingStageModel2;
  OnBoardingStageModel? onBoardingStageModel3;
  OnBoardingStageModel? onBoardingStageModel4;

  var stage1Submitting = false.obs;
  submitStage1(data) async {
    stage1Submitting.value = true;
    update();
    //page 1 name ,skills ,skills_name ,experience,dob,location,alternate_no
    var body = data ??
        {
          "name": nameController.text,
          "skills": skills,
          "skills_name": skillsController.text,
          "experience": experiencesController.text,
          "dob": birthController.text,
          "location": locationController.text,
          "alternate_no": alterNoController.text,
          "page": 1,
        };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage1Submitting.value = false;
        onBoardingStageModel1 = response;
        timer.cancel();
        divineSnackBar(
            data: onBoardingStageModel1!.message.toString(),
            color: appColors.green,
            duration: Duration(seconds: 5));
        // onBoardingList.remove(1);
        if (onBoardingList.contains(1)) {
          print("1 delete");
          onBoardingList.remove(1);
        } else {
          // print("1 not delete");
          // navigateToStage();
        }
        navigateToStage();

        // Get.offNamed(
        //   RouteName.onBoardingScreen2,
        // );

        update();
      } else {
        divineSnackBar(
            data: onBoardingStageModel1!.message.toString(),
            color: appColors.redColor,
            duration: Duration(seconds: 5));
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

  var stage2Submitting = false.obs;

  submitStage2() async {
    stage2Submitting.value = true;
    update();

    var body = {
      "aadhar_front": photoUrlAadharFront,
      "aadhar_back": photoUrlAadharBack,
      "aadhar_no": int.parse(aadharController.text.toString()),
      "pancard": photoUrlPanFront,
      "pancard_no": pancardController.text.toString(),
      "page": 2,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage2Submitting.value = false;
        onBoardingStageModel2 = response;
        divineSnackBar(
            data: onBoardingStageModel2!.message.toString(),
            color: appColors.green,
            duration: Duration(seconds: 5));
        if (onBoardingList.contains(2)) {
          onBoardingList.remove(2);
        } else {}
        navigateToStage();

        // Get.offNamed(
        //   RouteName.onBoardingScreen3,
        // );
        update();
      }
    } catch (error) {
      stage2Submitting.value = false;
      update();

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(
            data: error.toString(),
            color: appColors.redColor,
            duration: Duration(seconds: 5));
      }
    }
  }

  var stage3Submitting = false.obs;

  submitStage3() async {
    stage3Submitting.value = true;
    update();
    var body = {
      "astro_images": uploadedImages,
      "page": 3,
    };
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage3Submitting.value = false;
        onBoardingStageModel3 = response;
        print(onBoardingList.toString());
        update();
        if (onBoardingList.contains(3)) {
          onBoardingList.remove(3);
        } else {}
        navigateToStage();

        // Get.offNamed(
        //   RouteName.onBoardingScreen4,
        // );
        update();
      }
    } catch (error) {
      stage3Submitting.value = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(
            data: error.toString(),
            color: appColors.redColor,
            duration: Duration(seconds: 5));
      }
    }
  }

  var stage4Submitting = false.obs;

  submitStage4() async {
    stage4Submitting.value = true;
    update();
    var body = {
      "agreementData": agreementSignData,
      "page": 4,
    };
    print("body ----- ${body}");
    try {
      final response = await userRepository.onBoardingApiFun(body);
      if (response.success == true) {
        stage4Submitting.value = false;
        update();
        if (onBoardingList.contains(4)) {
          onBoardingList.remove(4);
        } else {}
        print(onBoardingList.toString());
        navigateToStage();
      }
    } catch (error) {
      stage4Submitting.value = false;

      debugPrint("error $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(
            data: error.toString(),
            color: appColors.redColor,
            duration: Duration(seconds: 5));
      }
    }
  }

  Future<String> loadPdfFromFile(String filePath) async {
    // Check if the file exists
    final File file = File(filePath);

    if (await file.exists()) {
      return file.path;
    } else {
      throw Exception("File not found");
    }
  }

  getAstrologerStatus() async {
    UserData? userData = await preference.getUserDetail();
    print("---------------${userData!.toJson().toString()}");
    try {
      print(
          "ApiProvider.astrologerAgreement - > ${ApiProvider.astrologerAgreement}${userData!.id}");
      Dio().options.headers = {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=5, max=1000',
      };
      final response =
          await Dio().get("${ApiProvider.astrologerAgreement}${userData!.id}");
      print("astrologerAgreement.data${jsonEncode(response.data)}");
      AgreementModel agreementModel = AgreementModel.fromJson(response.data);
      if (agreementModel.data != null) {
        exclusiveAgreementStages =
            agreementModel.data!.exclusiveAgreementStages!;
        print("exclusiveAgreementStages--->>$exclusiveAgreementStages");
        if (agreementModel.data!.stageMessage != null) {
          stageMessage = agreementModel.data!.stageMessage ?? "";
        } else {
          stageMessage = exclusiveAgreementStages == 2
              ? "Your Agreement is under-review"
              : exclusiveAgreementStages == 3
                  ? "Your Agreement is approved"
                  : exclusiveAgreementStages == 4
                      ? "Your Agreement not approved please retry aga"
                      : "";
        }

        update();
        downloadPDF(agreementModel.data!.pdfLink ?? "");
      }
    } catch (e) {
      print("getting error --- astrologerAgreement ${e}");
    }
  }

  String progressMessage = "";

  Future<void> downloadPDF(String url) async {
    try {
      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/astrologer_agreement.pdf';

      // Create Dio instance
      Dio dio = Dio();

      // Download the file
      await dio.download(url, filePath);
      pdfPath = loadPdfFromFile(filePath);
      update();
    } catch (e) {
      progressMessage = "Download failed: $e";
    }
  }

  Future<String>? pdfPath;
  bool isLastPage = false;

  /// 0(NotSend),1(pending sign),2(underRevie),3(approved),4(not approved)
  int exclusiveAgreementStages = 0;
  String stageMessage = "";

  // void navigateToStage() {
  //   if (onBoardingList.isEmpty) {
  //     // If the list is empty, go to the dashboard
  //     print("Navigating to onBoardingScreen5");
  //     if (isNextPage.value == 0) {
  //       Get.toNamed(RouteName.onBoardingScreen5);
  //     } else {
  //       if (isNextPage.value == 0) {
  //         switch (isNextPage.value) {
  //           case 1:
  //             print("Navigating to OnBoardingScreen1");
  //             isOnPage.value = 1;
  //             Get.offNamed(RouteName.onBoardingScreen);
  //             break;
  //           case 2:
  //             print("Navigating to OnBoardingScreen2");
  //             isOnPage.value = 2;
  //             Get.offNamed(RouteName.onBoardingScreen2);
  //             break;
  //           case 3:
  //             print("Navigating to OnBoardingScreen3");
  //             isOnPage.value = 3;
  //             Get.offNamed(RouteName.onBoardingScreen3);
  //             break;
  //           case 4:
  //             print("Navigating to OnBoardingScreen4");
  //             isOnPage.value = 4;
  //             Get.offNamed(RouteName.onBoardingScreen4);
  //             break;
  //           case 5:
  //             print("Navigating to addBankAutoMation");
  //             isOnPage.value = 5;
  //             Get.offNamed(RouteName.addBankAutoMation);
  //             break;
  //           case 6:
  //             print("Navigating to addEcomAutomation");
  //             isOnPage.value = 6;
  //             Get.offNamed(RouteName.addEcomAutomation);
  //             break;
  //           case 7:
  //             print("Navigating to scheduleTraining1");
  //             isOnPage.value = 7;
  //             Get.offNamed(RouteName.scheduleTraining1);
  //             break;
  //           case 8:
  //             print("Navigating to scheduleTraining2");
  //             isOnPage.value = 8;
  //             Get.offNamed(RouteName.scheduleTraining2);
  //             break;
  //         }
  //       }
  //     }
  //   } else {
  //     // Get the first value in the list
  //     int firstStage = onBoardingList.first;
  //
  //     // Check the first value and navigate accordingly
  //     switch (firstStage) {
  //       case 1:
  //         print("Navigating to OnBoardingScreen1");
  //         isOnPage.value = 1;
  //         Get.offNamed(RouteName.onBoardingScreen);
  //         break;
  //       case 2:
  //         print("Navigating to OnBoardingScreen2");
  //         isOnPage.value = 2;
  //         Get.offNamed(RouteName.onBoardingScreen2);
  //         break;
  //       case 3:
  //         print("Navigating to OnBoardingScreen3");
  //         isOnPage.value = 3;
  //         Get.offNamed(RouteName.onBoardingScreen3);
  //         break;
  //       case 4:
  //         print("Navigating to OnBoardingScreen4");
  //         isOnPage.value = 4;
  //         Get.offNamed(RouteName.onBoardingScreen4);
  //         break;
  //       case 5:
  //         print("Navigating to OnBoardingScreen5");
  //         isOnPage.value = 5;
  //         Get.offNamed(RouteName.onBoardingScreen5);
  //         break;
  //       default:
  //         if (isNextPage.value == 0) {
  //           switch (isNextPage.value) {
  //             case 1:
  //               print("Navigating to OnBoardingScreen1");
  //               isOnPage.value = 1;
  //               Get.offNamed(RouteName.onBoardingScreen);
  //               break;
  //             case 2:
  //               print("Navigating to OnBoardingScreen2");
  //               isOnPage.value = 2;
  //               Get.offNamed(RouteName.onBoardingScreen2);
  //               break;
  //             case 3:
  //               print("Navigating to OnBoardingScreen3");
  //               isOnPage.value = 3;
  //               Get.offNamed(RouteName.onBoardingScreen3);
  //               break;
  //             case 4:
  //               print("Navigating to OnBoardingScreen4");
  //               isOnPage.value = 4;
  //               Get.offNamed(RouteName.onBoardingScreen4);
  //               break;
  //             case 5:
  //               print("Navigating to addBankAutoMation");
  //               isOnPage.value = 5;
  //               Get.offNamed(RouteName.addBankAutoMation);
  //               break;
  //             case 6:
  //               print("Navigating to addEcomAutomation");
  //               isOnPage.value = 6;
  //               Get.offNamed(RouteName.addEcomAutomation);
  //               break;
  //             case 7:
  //               print("Navigating to scheduleTraining1");
  //               isOnPage.value = 7;
  //               Get.offNamed(RouteName.scheduleTraining1);
  //               break;
  //             case 8:
  //               print("Navigating to scheduleTraining2");
  //               isOnPage.value = 8;
  //               Get.offNamed(RouteName.scheduleTraining2);
  //               break;
  //           }
  //         }
  //         {}
  //         // If the value doesn't match any case, go to the dashboard
  //         print("Navigating to onBoardingScreen5 (default case)");
  //         Get.toNamed(RouteName.onBoardingScreen5);
  //         break;
  //     }
  //   }
  // }
  void navigateToStage() {
    // Helper function to handle navigation

    void navigateTo(int page, String routeName, argument) {
      isOnPage.value = page;
      if (argument == null) {
        Get.offNamed(
          routeName,
        );
      } else {
        Get.offNamed(routeName, arguments: argument);
      }
      print("Navigating to $routeName");
    }

    // Check if onBoardingList is empty
    if (onBoardingList.isEmpty) {
      print("Navigating to onBoardingScreen5 - ${isNextPage.value}");

      if (isNextPage.value == 0) {
        print("Navigating to onBoardingScreen5");
        Get.toNamed(RouteName.onBoardingScreen5);
      } else {
        // Navigate based on isNextPage value
        switch (isNextPage.value) {
          case 0:
            navigateTo(1, RouteName.onBoardingScreen, null);
            break;
          case 1:
            navigateTo(2, RouteName.onBoardingScreen2, null);
            break;
          case 2:
            navigateTo(3, RouteName.onBoardingScreen3, null);
            break;
          case 3:
            navigateTo(4, RouteName.onBoardingScreen4, null);
            break;
          case 4:
            navigateTo(5, RouteName.addBankAutoMation, null);
            break;
          case 5:
            navigateTo(6, RouteName.addEcomAutomation, null);
            break;
          case 6:
            navigateTo(7, RouteName.scheduleTraining1, null);
            break;
          case 7:
            navigateTo(8, RouteName.scheduleTraining2, "sheduled");
            break;
          default:
            print("Navigating to onBoardingScreen5 (default case)");
            Get.toNamed(RouteName.onBoardingScreen5);
            break;
        }
      }
    } else {
      // Navigate based on the first value in onBoardingList
      int firstStage = onBoardingList.first;
      switch (firstStage) {
        case 1:
          navigateTo(1, RouteName.onBoardingScreen, null);
          break;
        case 2:
          navigateTo(2, RouteName.onBoardingScreen2, null);
          break;
        case 3:
          navigateTo(3, RouteName.onBoardingScreen3, null);
          break;
        case 4:
          navigateTo(4, RouteName.onBoardingScreen4, null);
          break;
        case 5:
          navigateTo(5, RouteName.onBoardingScreen5, null);
          break;
        default:
          // Fallback for unexpected values
          print("Navigating to onBoardingScreen5 (default case)");
          Get.toNamed(RouteName.onBoardingScreen5);
          break;
      }
    }
  }

  // void navigateToStage() {
  //   if (onBoardingList.isEmpty) {
  //     print("dashboard");
  //     Get.toNamed(
  //       RouteName.dashboard,
  //     );
  //   } else {
  //     // Create a copy of the list to iterate over
  //     List<int> stagesToNavigate = List<int>.from(onBoardingList);
  //
  //     for (int stage in stagesToNavigate) {
  //       print(onBoardingList.toString());
  //       // Navigate to the screen based on the stage number
  //       switch (stage) {
  //         case 1:
  //           print(stage);
  //
  //           if (onBoardingList.length == 1) {
  //           } else {
  //             // onBoardingList.remove(1);
  //           }
  //           isOnPage.value == 1;
  //
  //           Get.toNamed(
  //             RouteName.onBoardingScreen,
  //           );
  //           break;
  //         case 2:
  //           print(stage);
  //
  //           if (onBoardingList.length == 1) {
  //           } else {
  //             // onBoardingList.remove(2);
  //           }
  //           // Navigate to the screen for stage 2
  //           isOnPage.value == 2;
  //
  //           Get.toNamed(
  //             RouteName.onBoardingScreen2,
  //           );
  //           break;
  //         case 3:
  //           if (onBoardingList.length == 1) {
  //           } else {
  //             // onBoardingList.remove(3);
  //           }
  //           // Navigate to the screen for stage 3
  //           isOnPage.value == 3;
  //
  //           Get.toNamed(
  //             RouteName.onBoardingScreen3,
  //           );
  //           break;
  //         case 4:
  //           if (onBoardingList.length == 1) {
  //           } else {
  //             // onBoardingList.remove(4);
  //           }
  //           // Navigate to the screen for stage 4
  //           isOnPage.value == 4;
  //
  //           Get.toNamed(
  //             RouteName.onBoardingScreen4,
  //           );
  //           break;
  //         case 5:
  //           if (onBoardingList.length == 1) {
  //           } else {
  //             // onBoardingList.remove(5);
  //           }
  //           isOnPage.value == 5;
  //
  //           // Navigate to the screen for stage 5
  //
  //           Get.toNamed(
  //             RouteName.onBoardingScreen5,
  //           );
  //           break;
  //         default:
  //           Get.toNamed(
  //             RouteName.dashboard,
  //           );
  //           break;
  //       }
  //     }
  //   }
  // }
  getAutoFillDataAssign(dataMap) {
    print('datadatadatadatadatadata: ${dataMap.toString()}');

    if (dataMap == null) {
    } else {
      // Example to handle different keys
      if (dataMap.containsKey('page')) {
        int page = dataMap['page'];
        print('Page: $page');
      }
      if (dataMap.containsKey('name')) {
        nameController.text = dataMap['name'].toString();
      }
      // if (dataMap.containsKey('skills')) {
      //   // Assuming dataMap['skills'] is a List<dynamic>, convert it to List<String>
      //   List<int> skillsList = List<int>.from(dataMap['skills']);
      //
      //   // // Update the text field
      //   // skillsController.text = skillsList.join(', ').toString();
      //
      //   // Assign the list to skills
      //   skills.assignAll(skillsList);
      // }
      // if (dataMap.containsKey('skills_name')) {
      //   // // Assuming dataMap['skills'] is a List<dynamic>, convert it to List<String>
      //   // List<int> skillsList = List<int>.from(dataMap['skills_name']);
      //   //
      //   // Update the text field
      //   skillsController.text = skillsList.join(', ').toString();
      //
      //   // // Assign the list to skills
      //   // skills.assignAll(skillsList);
      // }
      if (dataMap.containsKey('experience')) {
        experiencesController.text = dataMap['experience'].toString();
      }
      if (dataMap.containsKey('dob')) {
        birthController.text = dataMap['dob'].toString();
      }
      if (dataMap.containsKey('location')) {
        locationController.text = dataMap['location'].toString();
      }
      if (dataMap.containsKey('alternate_no')) {
        alterNoController.text = dataMap['alternate_no'].toString();
      }
      // For Page 2
      if (dataMap.containsKey('pancard')) {
        verifyPanFront = dataMap['pancard'];
        print('Pancard Image URL: $verifyPanFront');
      }
      if (dataMap.containsKey('aadhar_back')) {
        verifyAadharBack = dataMap['aadhar_back'];
        print('Pancard Image URL: $verifyAadharBack');
      }
      if (dataMap.containsKey('aadhar_front')) {
        verifyAadharFront = dataMap['aadhar_front'];
        print('Pancard Image URL: $verifyAadharFront');
      }
      if (dataMap.containsKey('aadhar_no')) {
        aadharController.text = dataMap['aadhar_no'].toString();
        print('Pancard Image URL: ${aadharController.text}');
      }
      if (dataMap.containsKey('pancard_no')) {
        pancardController.text = dataMap['pancard_no'].toString();
        print('Pancard Image URL: ${pancardController.text}');
      }
      // For Page 3
      if (dataMap.containsKey('astro_images')) {
        astroImagess = List<String>.from(dataMap['astro_images']);

        astroImages = List<String>.from(dataMap['astro_images']);
        // Replace values in the static list with images from the API
        for (int i = 0; i < astroImages.length && i < userImages.length; i++) {
          userImages[i] = astroImages[i];
        }
      }

      update();
      // if (dataMap.containsKey('skills')) {
      //   List<String> skills = List<String>.from(dataMap['skills']);
      //   print('Skills: $skills');
      // }

      // Handle other fields similarly
      dataMap.forEach((key, value) {
        print('$key: $value');
      });
    }
  }

  void showExitAppDialog() {
    Get.defaultDialog(
      title: 'Close App?',
      titleStyle: TextStyle(
        fontSize: 20,
        fontFamily: FontFamily.metropolis,
        fontWeight: FontWeight.w600,
        color: appColors.appRedColour,
      ),
      titlePadding: EdgeInsets.only(top: 20, bottom: 5),
      middleText:
          'You\'re just a few steps away from getting started with divinetalk.',
      middleTextStyle: TextStyle(
        fontSize: 14,
        fontFamily: FontFamily.poppins,
        fontWeight: FontWeight.w400,
        color: appColors.black.withOpacity(0.8),
      ),
      backgroundColor: appColors.white,
      radius: 10,
      barrierDismissible: true, // Can tap outside to close the dialog
      actions: [
        TextButton(
          onPressed: () {
            // Handle exit action
            exit(0);
          },
          child: Text(
            'Exit App',
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.metropolis,
              fontWeight: FontWeight.w600,
              color: appColors.darkBlue,
            ),
          ),
          style: TextButton.styleFrom(
            side: BorderSide(color: appColors.darkBlue),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle continue action
            Get.back(); // Close dialog
            // Add any other functionality you need
          },
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.metropolis,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: appColors.appRedColour,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class EditStttate {
  late CategoriesList categoriesList;
  void init() {
    final preferenceService = Get.find<SharedPreferenceService>();

    String specialityString = preferenceService.getSpecialAbility()!;
    categoriesList = categoriesDataFromJson(specialityString);
  }
}
