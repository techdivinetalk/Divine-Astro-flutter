import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../di/timer_duration_service.dart';
import '../../model/chat/chat_socket/chat_socket_init.dart';
import '../../model/chat/res_astro_chat_listener.dart';
import '../../model/chat_assistant/chat_assistant_chats_response.dart';
import '../../model/constant_details_model_class.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

const yourAppID = 696414715;
const yourAppSign =
    'bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa';


const yourServerSecret = '89ceddc6c59909af326ddb7209cb1c16';
RxList assistChatNewMsg = [].obs;
const livePath = "live";
const liveCountPath =  "liveCount";
RxInt chatAssistantCurrentUserId = 0.obs;
RxInt walletBalance = 0.obs;
RxList<AssistChatData> assistChatUnreadMessages = <AssistChatData>[].obs;
RxBool chatSwitch = false.obs;
RxBool callSwitch = false.obs;
RxBool videoSwitch = false.obs;
RxString userImage = ''.obs;


RxInt isEngagedStatus = 0.obs;
RxInt dasboardCurrentIndex = 0.obs;

const userChatData = "userChatData";
RxInt currentChatUserId = 8693.obs;
int roleId = 7;
ConstantDetailsModelClass globalConstantModel = ConstantDetailsModelClass();
var astroChatWatcher = ResAstroChatListener().obs;
TimeDurationService timer = TimeDurationService();
var chatSession = ResChatSocketInit().obs;



