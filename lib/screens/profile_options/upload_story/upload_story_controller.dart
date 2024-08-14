import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:video_trimmer/video_trimmer.dart';

import '../../../common/common_functions.dart';
import '../../../di/api_provider.dart';
import '../../../di/shared_preference_service.dart';
import '../../../model/res_login.dart';
import '../../../repository/user_repository.dart';

class UploadStoryController extends GetxController {
  Trimmer trimmer = Trimmer();
  RxBool? selectedFile = false.obs;

  double startValue = 0.0;
  double endValue = 0.0;
  RxBool isLoading = false.obs;
  RxBool isPlaying = false.obs;
  RxBool progressVisibility = false.obs;
  UserData? userData;
  var preference = Get.find<SharedPreferenceService>();
  final UserRepository userRepository = Get.find<UserRepository>();

  @override
  void onInit() {
    super.onInit();
    userData = preference.getUserDetail();

    if (Get.arguments != null) {
      trimmer.loadVideo(videoFile: File(Get.arguments));
      selectedFile?.value = true;
      update();
    }
  }

  saveVideo() {
    progressVisibility.value = true;
    trimmer.saveTrimmedVideo(
      startValue: startValue,
      endValue: endValue,
      storageDir: StorageDir.applicationDocumentsDirectory,
      videoFolderName: "trimmer video",
      videoFileName: "vid_${DateTime.now().microsecond}_${DateTime.now().millisecond}",
      onSave: (outputPath) async {
        int fileSizeInBytes = await File(outputPath ?? "").length();
        double sizeInKB = fileSizeInBytes / 1024;
        log("pick video size : $sizeInKB");
        log("maximumStorySize : ${maximumStorySize.value}");
        if(sizeInKB < double.parse(maximumStorySize.value.toString())){
          progressVisibility.value = false;
          Fluttertoast.showToast(msg: "${'uploadStory'.tr}..");
          await uploadImage(File(outputPath!));
        } else{
          Fluttertoast.showToast(
              msg: "Story video size should be maximum ${convertKBtoMB(double.parse(maximumStorySize.value.toString()))} MB",
            backgroundColor: appColors.red
          );
        }
        // uploadImageToS3Bucket(File(outputPath!),
        //     duration: ((endValue - startValue) / 1000).toString());
      },
    );
  }

  String convertKBtoMB(double sizeInKB) {
    return (sizeInKB / 1024).toStringAsFixed(0);
  }

  /*reduceVideoSize(String path) async {
    isLoading(true);
    final mediaInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    if(mediaInfo?.file?.path != null){
      int fileSizeInBytes = await File(mediaInfo!.file!.path).length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      log("compress video size : $fileSizeInMB");
      if(fileSizeInMB < 2){
        await uploadImage(File(mediaInfo.file!.path));
      } else{
        isLoading(false);
        Fluttertoast.showToast(msg: "Story video should be maximum 2 mb");
      }
    } else{
      isLoading(false);
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }*/

  uploadImageToS3Bucket(File? selectedFile, {String? duration}) async {
    log("1");
    // var commonConstants = await userRepository.constantDetailsData();
    log("2");
    // var dataString = commonConstants.data!.awsCredentails.baseurl?.split(".");
    log("3");
    // var extension = p.extension(selectedFile!.path);
    log("4");
    // var response = await AwsS3.uploadFile(
    //   accessKey: commonConstants.data!.awsCredentails.accesskey!,
    //   secretKey: commonConstants.data!.awsCredentails.secretKey!,
    //   file: selectedFile,
    //   bucket: dataString![0].split("//")[1],
    //   destDir: 'astrologer/${userData?.id}',
    //   filename: '${DateTime.now().millisecondsSinceEpoch.toString()}$extension',
    //   region: dataString[2],
    // );
    // if (response != null) {
    //   debugPrint("Uploaded Url : $response");
    //   // await uploadStory(response, duration: duration);
    //   CustomException("Video uploaded successfully");
    // } else {
    //   CustomException("Something went wrong");
    // }
  }

  uploadImage(imageFile) async {
    var uploadedStory;
    // isLoading(true);
    var token = await preferenceService.getToken();
    log("image length - ${imageFile.path}");

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
    request.fields.addAll({"module_name": "astrologer_story"});

    print("call this one ----> 1");
    var response = await request.send();
    print("call this one ----> 2");

    // Listen for the response
    log(response.toString());
    // Listen for the response
    response.stream.transform(utf8.decoder).listen((value) {
      if (value.isEmpty) {
        isLoading(false);
      }
      print(value); // Handle the response from the server
      uploadedStory = jsonDecode(value)["data"]["path"];
      update();
      print(
          "Image uploaded successfully. --  - ${jsonDecode(value)["data"]["full_path"].toString()}");
      uploadStory(jsonDecode(value)["data"]["full_path"].toString());
      print(
          "valuevaluevaluevaluevaluevaluevalue"); // Handle the response from the server
    });

    if (response.statusCode == 200) {
      print("Image uploaded successfully.");
      // uploadStory(uploadedStory.toString());
    } else {
      print("Failed to upload image.");
    }
  }

  String encodeString(String originalString) {
    String encodedString = base64Encode(utf8.encode(originalString));
    return encodedString;
  }

  String encodedURLFunction() {
    final Map<dynamic, dynamic> map = {
      "astrologer_id": userData?.id.toString(),
    };
    final Uri encoded = Uri.parse("https://divinetalk.in");
    final String path = "page=astrologerProfile&param=${json.encode(map)}";
    final String encode = encodeString(path);
    final String fullEncodeURL = "${encoded.scheme}://${encoded.host}?$encode";
    return fullEncodeURL;
  }

  Future<void> uploadStory(String url, {String? duration}) async {
    String fullEncodeURL = encodedURLFunction();
    print("fullEncodeURL: $fullEncodeURL");

    try {
      Map<String, dynamic> param = {
        "media_url": url,
        "astrologer_id": userData?.id,
        "duration": duration,
        "link": fullEncodeURL,
      };
      final response = await userRepository.uploadAstroStory(param);
      if (response.statusCode == 200 && response.success == true) {
        Get.back();
        isLoading(false);

        divineSnackBar(data: "Story Uploaded Successfully");
      }
    } catch (err) {
      isLoading(false);

      Fluttertoast.showToast(msg: "Something went wrong");
      log(err.toString());
    }
  }
}
