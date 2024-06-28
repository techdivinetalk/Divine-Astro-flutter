import 'package:carousel_slider/carousel_slider.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

class NoticeBoardWidget extends StatelessWidget {
  final NewChatController? controller;
  const NoticeBoardWidget({super.key,this.controller});

  @override
  Widget build(BuildContext context) {
    return controller!.noticeDataChat.isNotEmpty
        ? CarouselSlider(
      options: CarouselOptions(
        height: 50,
        autoPlay: true,
        aspectRatio: 1,
        viewportFraction: 1,
      ),
      items: controller!.noticeDataChat.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              margin:
              const EdgeInsets.symmetric(horizontal: 10),
              padding:
              const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xffDA2439)),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: HTML.toTextSpan(
                    context, i.description ?? ""),
                maxLines: 2,
              ),
            );
          },
        );
      }).toList(),
    )
        : const SizedBox.shrink();
  }
}
