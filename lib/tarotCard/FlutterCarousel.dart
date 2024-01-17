import 'package:carousel_slider/carousel_controller.dart';
import 'package:divine_astrologer/screens/chat_message_with_socket/chat_message_with_socket_controller.dart';
import 'package:divine_astrologer/tarotCard/src/_flutter_carousel_widget.dart';
import 'package:divine_astrologer/tarotCard/src/components/image_constant.dart';
import 'package:divine_astrologer/tarotCard/src/helpers/flutter_carousel_options.dart';
import 'package:divine_astrologer/tarotCard/widget/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../common/colors.dart';
import '../common/common_bottomsheet.dart';

// class FlutterCarouselWidgetDemo extends StatelessWidget {
//   const FlutterCarouselWidgetDemo({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             //selectPlaceOfBirth(context);
//             openBottomSheet(
//               context,
//               functionalityWidget:  SelectCardCount(),
//             );
//           },
//           child: const Text('Show Modal Bottom Sheet'),
//         ),
//       ),
//     );
//   }
// }

class Slide {
  Slide({
    required this.title,
    required this.height,
    required this.color,
  });

  final Color color;
  final double height;
  final String title;
}

/* =============================== Show Card three ====================================*/

Future<void> showOneCard(
  BuildContext context,
) async {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => const OneCardView(),
  );
}

class OneCardView extends StatefulWidget {
  const OneCardView({Key? key}) : super(key: key);

  @override
  State<OneCardView> createState() => _OneCardViewState();
}

class _OneCardViewState extends State<OneCardView> {
  // This list holds the current titles for each slide.
  late List<String> slideTitles;
  late List<String> cardData;

  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    cardData = [];
    // Initialize the slideTitles with "Slide 1", "Slide 2", etc.
    slideTitles = List.generate(6, (index) => 'Slide ${index + 1}');
  }

  void _onTapSlide(int index) {
    setState(() {
      // Change the title of the tapped slide to "Slide X".
      // This is where you can cycle through different texts as needed.
      slideTitles[index] = 'New Item ${index + 1}';
    });
  }

  @override
  Widget build(BuildContext context) {
    var slides = List.generate(
      6,
      (index) => Slide(
        title: 'Slide ${index + 1}',
        height: 100.0 + index * 50,
        color: Colors.primaries[index % Colors.primaries.length],
      ),
    );
    // Ensure your 'sliders' data is correctly initialized
    final List<Widget> sliders = slides
        .asMap() // Use asMap to keep track of the index
        .entries
        .map(
      (entry) {
        int idx = entry.key;
        Slide item = entry.value;
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          child: GestureDetector(
            onTap: () {
              if (cardData.length < 1) {
                cardData.add('Slide ${idx + 1}');
                setState(() {});
              }
              print('Slide ${idx + 1}'); // Print Slide 1, Slide 2, etc.
            },
            child: CustomImageView(
              imagePath: ImageConstant.img1, /*alignment: Alignment.center*/
            ),
          ),
        );
      },
    ).toList();

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: AppColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: context.width,
              height: context.height / 1.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0), // Top-left corner
                  topRight: Radius.circular(15.0), // Top-right corner
                ),
                // borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.black45,
                border: Border(
                  top: BorderSide(color: Color(0xffFCD194)), // Top border
                  bottom: BorderSide(color: Color(0xffFCD194)), // Bottom border
                  left: BorderSide(color: Color(0xffFCD194)), // Left border
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Scroll and Pick Your Card',
                      style: TextStyle(
                        color: Color(0xffFCD194),
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: FlutterCarousel(
                              options: CarouselOptions(
                                autoPlay: false,
                                height: 120,
                                autoPlayInterval: const Duration(seconds: 10),
                                viewportFraction: 0.2,
                                enlargeCenterPage: true,
                                floatingIndicator: false,
                                enableInfiniteScroll: true,
                              ),
                              items: sliders),
                        ),
                        Positioned(
                          left: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xffFCD194),
                            ),
                            onPressed: () {
                              // _carouselController.previousPage();
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffFCD194),
                            ),
                            onPressed: () {
                              // _carouselController.nextPage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 120, // Set the height for the card row
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(1, (index) {
                          // Replace 3 with 5 if you want 5 items
                          return Card(
                            color: Colors.black54,
                            // Background color for cards, change as needed
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4,
                              // Equal width for items, adjust the gap with -20
                              child: Center(
                                child: cardData.length > index
                                    ? CustomImageView(
                                        imagePath: ImageConstant.img1,
                                        height: 80,
                                        width: 50,
                                        alignment: Alignment.center)
                                    : Container(), // Replace with your actual content
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const Opacity(opacity: 0.2, child: Divider()),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Note : ',
                          style:
                              TextStyle(color: Color(0xffFCD194), fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'We’ll send the chosen tarot cards to our astrologer and they will do a tarot card reading for you.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ).px20(),
                  // Single horizontal line
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                            .copyWith(bottom: viewBottomPadding(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: cardData.length == 1
                                  ? const Color(0xffFCD194)
                                  : const Color(0xFF2F2F2F), //
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () {
                              if (cardData.length == 1) {}
                            },
                            child: const Text(
                              'Send Cards',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: AppColors.brown,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double viewBottomPadding(double padding) {
    return Get.mediaQuery.viewPadding.bottom > 0
        ? Get.mediaQuery.viewPadding.bottom
        : padding;
  }
}

/* =============================== Show Card three ====================================*/

Future<void> showThreeCard(
  BuildContext context,
) async {
  showCupertinoModalPopup(
    context: context,
    builder: (context) => const ThreeCardWidget(),
  );
}

class ThreeCardWidget extends StatefulWidget {
  const ThreeCardWidget({Key? key}) : super(key: key);

  @override
  State<ThreeCardWidget> createState() => _ThreeCardWidgetState();
}

class _ThreeCardWidgetState extends State<ThreeCardWidget> {
  // This list holds the current titles for each slide.
  late List<String> slideTitles;
  late List<String> cardData;

  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    cardData = [];
    // Initialize the slideTitles with "Slide 1", "Slide 2", etc.
    slideTitles = List.generate(6, (index) => 'Slide ${index + 1}');
  }

  void _onTapSlide(int index) {
    setState(() {
      // Change the title of the tapped slide to "Slide X".
      // This is where you can cycle through different texts as needed.
      slideTitles[index] = 'New Item ${index + 1}';
    });
  }

  @override
  Widget build(BuildContext context) {
    var slides = List.generate(
      6,
      (index) => Slide(
        title: 'Slide ${index + 1}',
        height: 100.0 + index * 50,
        color: Colors.primaries[index % Colors.primaries.length],
      ),
    );
    // Ensure your 'sliders' data is correctly initialized
    final List<Widget> sliders = slides
        .asMap() // Use asMap to keep track of the index
        .entries
        .map(
      (entry) {
        int idx = entry.key;
        Slide item = entry.value;
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          child: GestureDetector(
            onTap: () {
              if (cardData.length < 3) {
                cardData.add('Slide ${idx + 1}');
                setState(() {});
              }
              print('Slide ${idx + 1}'); // Print Slide 1, Slide 2, etc.
            },
            child: CustomImageView(
              imagePath: ImageConstant.img1, /*alignment: Alignment.center*/
            ),
          ),
        );
      },
    ).toList();

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: AppColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: context.width,
              height: context.height / 1.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0), // Top-left corner
                  topRight: Radius.circular(15.0), // Top-right corner
                ),
                // borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.black45,
                border: Border(
                  top: BorderSide(color: Color(0xffFCD194)), // Top border
                  bottom: BorderSide(color: Color(0xffFCD194)), // Bottom border
                  left: BorderSide(color: Color(0xffFCD194)), // Left border
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Scroll and Pick Your Card',
                      style: TextStyle(
                        color: Color(0xffFCD194),
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: FlutterCarousel(
                              options: CarouselOptions(
                                autoPlay: false,
                                height: 120,
                                autoPlayInterval: const Duration(seconds: 10),
                                viewportFraction: 0.2,
                                enlargeCenterPage: true,
                                floatingIndicator: false,
                                enableInfiniteScroll: true,
                              ),
                              items: sliders),
                        ),
                        Positioned(
                          left: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xffFCD194),
                            ),
                            onPressed: () {
                              // _carouselController.previousPage();
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffFCD194),
                            ),
                            onPressed: () {
                              // _carouselController.nextPage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 120, // Set the height for the card row
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) {
                          // Replace 3 with 5 if you want 5 items
                          return Card(
                            color: Colors.black54,
                            // Background color for cards, change as needed
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3 - 40,
                              // Equal width for items, adjust the gap with -20
                              child: Center(
                                child: cardData.length > index
                                    ? CustomImageView(
                                        imagePath: ImageConstant.img1,
                                        height: 80,
                                        width: 50,
                                        alignment: Alignment.center)
                                    : Container(), // Replace with your actual content
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const Opacity(opacity: 0.2, child: Divider()),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Note : ',
                          style:
                              TextStyle(color: Color(0xffFCD194), fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'We’ll send the chosen tarot cards to our astrologer and they will do a tarot card reading for you.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ).px20(),
                  // Single horizontal line
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                            .copyWith(bottom: viewBottomPadding(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: cardData.length == 3
                                  ? const Color(0xffFCD194)
                                  : const Color(0xFF2F2F2F), //
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () {
                              if (cardData.length == 2) {}
                            },
                            child: const Text(
                              'Send Cards',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: AppColors.brown,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double viewBottomPadding(double padding) {
    return Get.mediaQuery.viewPadding.bottom > 0
        ? Get.mediaQuery.viewPadding.bottom
        : padding;
  }
}

/* =============================== Show Card three ====================================*/

Future<void> showFiveCard(BuildContext context, dynamic choice) async {
  // Specify the type of choice if it's not dynamic
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => FiveCardWidget(choice: choice),
  );
}

class FiveCardWidget extends StatefulWidget {
  final dynamic choice; // Define the type of choice if it's not dynamic

  // The constructor should use this.choice to initialize the choice property
  const FiveCardWidget({required this.choice, Key? key}) : super(key: key);

  @override
  State<FiveCardWidget> createState() => _FiveCardWidgetState(choice);
}

class _FiveCardWidgetState extends State<FiveCardWidget> {
  // This list holds the current titles for each slide.
  late List<String> slideTitles;
  late List<String> cardData;

  final CarouselController _carouselController = CarouselController();
  final dynamic choice; // Define the type of choice if it's not dynamic
  _FiveCardWidgetState(this.choice);

  @override
  void initState() {
    super.initState();
    cardData = [];
    // Initialize the slideTitles with "Slide 1", "Slide 2", etc.
    slideTitles = List.generate(6, (index) => 'Slide ${index + 1}');
  }

  void _onTapSlide(int index) {
    setState(() {
      // Change the title of the tapped slide to "Slide X".
      // This is where you can cycle through different texts as needed.
      slideTitles[index] = 'New Item ${index + 1}';
    });
  }

  @override
  Widget build(BuildContext context) {
    var slides = List.generate(
      6,
      (index) => Slide(
        title: 'Slide ${index + 1}',
        height: 100.0 + index * 50,
        color: Colors.primaries[index % Colors.primaries.length],
      ),
    );
    // Ensure your 'sliders' data is correctly initialized
    final List<Widget> sliders = slides
        .asMap() // Use asMap to keep track of the index
        .entries
        .map(
      (entry) {
        int idx = entry.key;
        Slide item = entry.value;
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          child: GestureDetector(
            onTap: () {
              if (cardData.length < 5) {
                cardData.add('Slide ${idx + 1}');
                setState(() {});
              }
              print('Slide ${idx + 1}'); // Print Slide 1, Slide 2, etc.
            },
            child: CustomImageView(
              imagePath: ImageConstant.img1, /*alignment: Alignment.center*/
            ),
          ),
        );
      },
    ).toList();

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: AppColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: context.width,
              height: context.height / 1.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0), // Top-left corner
                  topRight: Radius.circular(15.0), // Top-right corner
                ),
                // borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.black45,
                border: Border(
                  top: BorderSide(color: Color(0xffFCD194)), // Top border
                  bottom: BorderSide(color: Color(0xffFCD194)), // Bottom border
                  left: BorderSide(color: Color(0xffFCD194)), // Left border
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Scroll and Pick Your Card',
                      style: TextStyle(
                        color: Color(0xffFCD194),
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: FlutterCarousel(
                              options: CarouselOptions(
                                autoPlay: false,
                                height: 120,
                                autoPlayInterval: const Duration(seconds: 10),
                                viewportFraction: 0.2,
                                enlargeCenterPage: true,
                                floatingIndicator: false,
                                enableInfiniteScroll: true,
                              ),
                              items: sliders),
                        ),
                        Positioned(
                          left: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xffFCD194),
                            ),
                            onPressed: () {
                              // _carouselController.previousPage();
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffFCD194),
                            ),
                            onPressed: () {
                              // _carouselController.nextPage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 120, // Set the height for the card row
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          // Replace 3 with 5 if you want 5 items
                          return Card(
                            color: Colors.black54,
                            // Background color for cards, change as needed
                            child: Container(
                              width: MediaQuery.of(context).size.width / 5 - 10,
                              // Equal width for items, adjust the gap with -20
                              child: Center(
                                child: cardData.length > index
                                    ? CustomImageView(
                                        imagePath: ImageConstant.img1,
                                        height: 80,
                                        width: 50,
                                        alignment: Alignment.center)
                                    : Container(), // Replace with your actual content
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const Opacity(opacity: 0.2, child: Divider()),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Note : ',
                          style:
                              TextStyle(color: Color(0xffFCD194), fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'We’ll send the chosen tarot cards to our astrologer and they will do a tarot card reading for you.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ).px20(),
                  // Single horizontal line
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                            .copyWith(bottom: viewBottomPadding(15)),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: cardData.length == 5
                                  ? const Color(0xffFCD194)
                                  : const Color(0xFF2F2F2F), //
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () {
                              if (cardData.length == 4) {}
                            },
                            child: const Text(
                              'Send Cards',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: AppColors.brown,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  double viewBottomPadding(double padding) {
    return Get.mediaQuery.viewPadding.bottom > 0
        ? Get.mediaQuery.viewPadding.bottom
        : padding;
  }
}

/*============================================== Bottom Sheet  ==============================================================*/
void showCardChoiceBottomSheet(BuildContext context, ChatMessageWithSocketController controller) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return CardChoiceBottomSheet(controller);
    },
  );
}


class CardChoiceBottomSheet extends StatefulWidget {
  final ChatMessageWithSocketController controller;

  CardChoiceBottomSheet(this.controller);

  @override
  _CardChoiceBottomSheetState createState() =>
      _CardChoiceBottomSheetState(controller);
}

class _CardChoiceBottomSheetState extends State<CardChoiceBottomSheet> {
  int? _choice;
  bool isVisible = false;
  ChatMessageWithSocketController controller;

  _CardChoiceBottomSheetState(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Show Card Deck to User',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Opacity(
                opacity: 0, // Invisible IconButton to balance the row alignment
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: null,
                ),
              ),
            ],
          ),
          Visibility(
            visible: !isVisible,
            child: Container(
                child: Column(
              children: [
                ListTile(
                  leading: Radio<int>(
                    value: 1,
                    groupValue: _choice,
                    onChanged: (int? value) {
                      setState(() {
                        _choice = value;
                      });
                    },
                  ),
                  title: const Text('Ask user to choose a card'),
                ),
                ListTile(
                  leading: Radio<int>(
                    value: 3,
                    groupValue: _choice,
                    onChanged: (int? value) {
                      setState(() {
                        _choice = value;
                      });
                    },
                  ),
                  title: const Text('Ask user to choose 3 cards'),
                ),
                ListTile(
                  leading: Radio<int>(
                    value: 5,
                    groupValue: _choice,
                    onChanged: (int? value) {
                      setState(() {
                        _choice = value;
                      });
                    },
                  ),
                  title: const Text('Ask user to choose 5 cards'),
                )
              ],
            )),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // Border color
                width: 1.0, // Border width
              ),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [const Text('Name'), const Text('05 M 30 S')],
                  ),
                  Spacer(), // This will create the gap in the middle
                  ElevatedButton(
                    onPressed: _choice != null
                        ? () {
                            isVisible = true;
                            Get.back();
                            setState(() {});
                            controller.sendTarotCard(_choice);
                            // Logic to handle send action
                            print('Selected choice: $_choice');

                            //showFiveCard(context,_choice);
                          }
                        : null, // Button is disabled if _choice is null
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _choice != null
                          ? AppColors.appColorDark
                          : Colors
                              .grey, // Button color changes based on selection
                    ),
                    child: Text(isVisible ? '....' : 'Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class SelectCardCount extends  StatelessWidget{
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.white, width: 1.5),
//                 borderRadius: const BorderRadius.all(Radius.circular(50.0)),
//                 color: AppColors.transparent),
//             child: const Icon(
//               Icons.close,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         Container(
//           width: double.maxFinite,
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
//             color: AppColors.white,
//           ),
//           child: Column(
//             children: [
//               GestureDetector(
//                  onTap: () {
//                    Get.back();
//                    showOneCard(context);
//                  },
//                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                   Container(
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: const BoxDecoration(),
//                       child: Text("choose card 1".tr,)),
//                   Container(
//                       height: 20,
//                       width: 20,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.h),
//                           border: Border.all(
//                               width: 1.h)))
//                 ]),
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   Get.back();
//                   showThreeCard(context);
//                 },
//                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                   Container(
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: const BoxDecoration(),
//                       child: Text("choose card 3".tr,)),
//                   Container(
//                       height: 20,
//                       width: 20,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.h),
//                           border: Border.all(
//                               width: 1.h)))
//                 ]),
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   Get.back();
//                  // showFiveCard(context);
//                 },
//                 child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                   Container(
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: const BoxDecoration(),
//                       child: Text("choose card 5".tr,)),
//                   Container(
//                       height: 20,
//                       width: 20,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.h),
//                           border: Border.all(
//                               width: 1.h)))
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
