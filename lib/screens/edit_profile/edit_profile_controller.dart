import 'package:get/get.dart';

class EditProfileController extends GetxController {
  var tagIndexes = [1].obs;

  var tags = ['Vedic'].obs;
  RxInt tag = 0.obs;
  // list of string options
  var options = [
    'Tarot',
    'Vedic',
    'Numerology',
    'Prashana',
    'Vastu',
    'Palmistry',
    'Reiki Healing',
    'Counsellor',
    'Face Reading',
    'Counsellor',
  ].obs;
}