import 'package:flutter/material.dart';

import '../../common/colors.dart';
import '../../gen/fonts.gen.dart';
import '../../model/chat_offline_model.dart';

class CommonReadWidget extends StatelessWidget {
  final ChatMessage? chatDetail;
  const CommonReadWidget({super.key, required this.chatDetail});

  @override
  Widget build(BuildContext context) {
    return  Text(
        chatDetail!.type == 0
            ? "unseen"
            : chatDetail!.type == 3
            ? "seen":"unseen" , 
        style: TextStyle(
            fontSize: 7,
            color:   chatDetail!.type == 0 ? appColors.greyColor :appColors.guideColor,
            fontFamily: FontFamily.metropolis,
            fontWeight: FontWeight.w500));
  }
}
