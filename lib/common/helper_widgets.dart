import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class HelpersWidget{
  Widget emptyChatWidget(){
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.emptyBox1.image(),
            Text("Nothing here!")
          ],
        ));
  }
}