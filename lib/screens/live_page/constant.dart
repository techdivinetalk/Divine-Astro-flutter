import 'dart:math' as math;

import 'package:get/get.dart';

import '../../model/chat/res_astro_chat_listener.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

const yourAppID = 696414715;
const yourAppSign =
    'bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa';

const yourServerSecret = '89ceddc6c59909af326ddb7209cb1c16';

const userChatData = "userChatData";
RxInt currentChatUserId = 8693.obs;
int roleId = 7;
var astroChatWatcher = ResAstroChatListener().obs;
