import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FrontCameraView extends StatefulWidget {
  const FrontCameraView({super.key,this.cameras});

  final List<CameraDescription>? cameras;

  @override
  State<FrontCameraView> createState() => _FrontCameraViewState();
}

class _FrontCameraViewState extends State<FrontCameraView> {

  late CameraController _cameraController;
  @override
  void initState() {
    initCamera(widget.cameras![1]);
    super.initState();

  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Stack(children: [
          (_cameraController.value.isInitialized)
              ? CameraPreview(_cameraController)
              : Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator())),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    color: Colors.black),
                child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                      child: IconButton(
                        onPressed: takePicture,
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.circle, color: Colors.white),
                      )),
                  // const Spacer(),

                ]),
              )),
        ]),
      )
    );
  }

  Future takePicture() async {
    print("CameraIssue0");
    if (!_cameraController.value.isInitialized) {
      print("CameraIssue1");
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      print("CameraIssue2");
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      Get.back(result: picture.path);
    } on CameraException catch (e) {
      print("CameraIssue4");
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
}
