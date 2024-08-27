import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../common/common_functions.dart';
import '../../common/permission_handler.dart';
import '../../common/routes.dart';
import '../../di/api_provider.dart';
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
  List skills = [""];
  List astroImages = [];
  updatePage(page) {
    currentPage = page;
    update();
  }

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
  }

  void checkSelectedImages() {
    int selectedCount = userImages.where((element) => element is File).length;
    if (selectedCount >= 2) {
      Get.toNamed(
        RouteName.onBoardingScreen4,
      );
      print("User has selected 2 or more images.");
      // You can proceed with your logic here
      // For example, enabling a submit button or showing a message
    } else {
      Fluttertoast.showToast(msg: "Please select more then 2 images");
      print("User has not selected enough images.");
      // Handle the case where less than 2 images are selected
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
            selectedAadharFront = File(result.path);
          } else if (selected == "ab") {
            selectedAadharBack = File(result.path);
          } else if (selected == "pan") {
            selectedPanFront = File(result.path);
          } else if (selected == "profile") {
            selectedProfile = File(result.path.toString());
          } else {
            print("----image---- ${userImages.toString()}");

            userImages[selected] = File(result.path
                .toString()); // Update the value with the selected image
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

  Future<void> uploadImage(imageFile, imageType) async {
    switch (imageType) {
      case 'Profile':
        loadingProfile = true;
        break;
      case 'aadharFront':
        loadingAadharFront = true;
        break;
      case 'aadharBack':
        loadingAadharFront = true;
        break;
      case 'panFront':
        loadingAadharFront = true;
        break;
    }
    var token = await preferenceService.getToken();

    print("image length - ${imageFile.path}");

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
            case 'Profile':
              loadingProfile = false;

              photoUrlprofile = imageUrl;

              break;
            case 'aadharFront':
              loadingAadharFront = false;

              photoUrlAadharFront = imageUrl;
              break;
            case 'aadharBack':
              loadingAadharFront = false;

              photoUrlAadharBack = imageUrl;
              break;
            case 'panFront':
              loadingAadharFront = false;

              photoUrlPanFront = imageUrl;
              break;
          }
        }

        // if (image.isNotEmpty) {
        //   poojaImageUrl = image;
        // }
      } else {
        print("Failed to upload image.");
      }
    });
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
      "profile_picture": selectedProfile,
      "aadhar_front": selectedAadharFront,
      "aadhar_back": selectedAadharBack,
      "pancard": selectedPanFront,
      "astro_images": userImages,
    };
    print("-----------data------${jsonData.toString()}");
  }
}
