import "dart:ui";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/model/live/deck_card_model.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/common_button.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class ChosenCards extends StatefulWidget {
  const ChosenCards({
    required this.onClose,
    required this.userName,
    required this.userChosenCards,
    super.key,
  });

  final void Function() onClose;
  final String userName;
  final List<DeckCardModel> userChosenCards;

  @override
  State<ChosenCards> createState() => _ChosenCardsState();
}

class _ChosenCardsState extends State<ChosenCards> {
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
            "Chosen Cards",
            style: TextStyle(fontSize: 20, color: AppColors.white),
          ),
          // const SizedBox(height: 16),
          DynamicHeightGridView(
            shrinkWrap: true,
            itemCount: widget.userChosenCards.length,
            crossAxisCount: widget.userChosenCards.length,
            builder: (BuildContext context, int index) {
              final DeckCardModel model = widget.userChosenCards[index];
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.width / 2.5,
                      width: Get.width / 4,
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
                    const SizedBox(height: 8),
                    Text(
                      model.name ?? "",
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          CommonButton(
            buttonText: "Done",
            buttonCallback: widget.onClose,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
