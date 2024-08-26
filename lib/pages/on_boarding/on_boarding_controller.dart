import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/permission_handler.dart';
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

  var currentPage = 1;

  updatePage(page) {
    currentPage = page;
    update();
  }

  File? image;
  final picker = ImagePicker();
  XFile? pickedFile;
  File? uploadFile;

  var selectedAadharFront;
  var selectedAadharBack;
  var selectedPanFront;

  List userImages = [1, 2, 3, 4, 5];

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
          } else {
            print("----image---- ${userImages.toString()}");

            userImages[selected] = result.path;
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
}
