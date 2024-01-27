import "dart:ui";

import "package:carousel_slider/carousel_slider.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/model/live/deck_card_model.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class LiveCarousal extends StatefulWidget {
  const LiveCarousal({
    required this.onClose,
    required this.numOfSelection,
    required this.onSelect,
    required this.allCards,
    required this.userName,
    super.key,
  });

  final void Function() onClose;
  final int numOfSelection;
  final void Function(List<DeckCardModel> value) onSelect;
  final List<DeckCardModel> allCards;
  final String userName;

  @override
  State<LiveCarousal> createState() => _LiveCarousalState();
}

class _LiveCarousalState extends State<LiveCarousal> {
  final List<DeckCardModel> numList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.numOfSelection; i++) {
      numList.add(DeckCardModel());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[top(), const SizedBox(height: 16), bottom()],
      ),
    );
  }

  Widget top() {
    return InkWell(
      onTap: widget.onClose,
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: AppColors.white),
            color: AppColors.white.withOpacity(0.2),
          ),
          child: const Icon(Icons.close, color: AppColors.white),
        ),
      ),
    );
  }

  Widget bottom() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50.0),
        topRight: Radius.circular(50.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          // height: Get.height / 1.50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            border: Border.all(color: AppColors.yellow),
            color: AppColors.white.withOpacity(0.2),
          ),
          child: grid(),
        ),
      ),
    );
  }

  Widget grid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          const Text(
            "Scroll and Pick Your Cards",
            style: TextStyle(fontSize: 20, color: AppColors.yellow),
          ),
          const SizedBox(height: 16),
          CarouselSlider.builder(
            itemCount: widget.allCards.length,
            options: CarouselOptions(
              height: Get.height / 4.80,
              viewportFraction: 0.20,
              initialPage: 0,
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
              enlargeFactor: 0.20,
              scrollDirection: Axis.horizontal,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
            ),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final DeckCardModel model = widget.allCards[index];
              return InkWell(
                onTap: () {
                  autoInsertValue(model);
                  setState(() {});
                },
                child: Container(
                  height: Get.height / 4.80,
                  width: Get.width / 4,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    child: CustomImageWidget(
                      imageUrl: model.image ?? "",
                      rounded: false,
                      typeEnum: TypeEnum.user,
                    ),
                  ),
                ),
              );
            },
          ),
          // const SizedBox(height: 16),
          DynamicHeightGridView(
            shrinkWrap: true,
            itemCount: widget.numOfSelection,
            crossAxisCount: widget.numOfSelection,
            builder: (BuildContext context, int index) {
              final DeckCardModel model = numList[index];
              return Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: Get.height / 4.80,
                          width: Get.width / 4,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            child: !mapEquals(
                                    DeckCardModel().toJson(), model.toJson())
                                ? CustomImageWidget(
                                    imageUrl: model.image ?? "",
                                    rounded: false,
                                    typeEnum: TypeEnum.user,
                                  )
                                : const Card(child: Icon(Icons.add)),
                          ),
                        ),
                        !mapEquals(DeckCardModel().toJson(), model.toJson())
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    removeAt(index);
                                    setState(() {});
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: AppColors.yellow,
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      model.name ?? "Not Selected",
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            "Note : We'll send the chosen tarot cards to our live astrologer and they will do a live tarot card reading for you.",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 60, width: double.infinity, child: button()),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void autoInsertValue(DeckCardModel model) {
    final int emptyIndex = numList.indexWhere((element) => element.id == null);
    numList[emptyIndex] = model;
  }

  void removeAt(int index) {
    numList[index] = DeckCardModel();
  }

  bool condition() {
    final list = numList.where((element) => element.id == null).toList();
    return list.isNotEmpty;
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        backgroundColor: MaterialStateProperty.all(
          condition() ? AppColors.grey : AppColors.yellow,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
      onPressed: () {
        widget.onSelect(numList);
      },
      child: Text(
        'Send',
        style: TextStyle(
          color: condition() ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}
