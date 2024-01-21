import "dart:async";
import "dart:convert";

import "package:after_layout/after_layout.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/model/live/deck_card_model.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/chosen_cards.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/live_carousal.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/show_card_deck_to_user.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/waiting_for_user_to_select_cards.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:shared_preferences/shared_preferences.dart';

class Blank extends StatefulWidget {
  const Blank({
    super.key,
  });

  @override
  State<Blank> createState() => _BlankState();
}

class _BlankState extends State<Blank> with AfterLayoutMixin<Blank> {
  List<DeckCardModel> deckCardModel = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: showCardDeckToUserPopup,
              child: const Text("showCardDeckToUserPopup"),
            ),
            ElevatedButton(
              onPressed: waitingForUserToSelectCardsPopup,
              child: const Text("waitingForUserToSelectCardsPopup"),
            ),
            ElevatedButton(
              onPressed: chosenCardsPopup,
              child: const Text("chosenCardsPopup"),
            ),
            ElevatedButton(
              onPressed: liveCarousalPopup,
              child: const Text("liveCarousalPopup"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showCardDeckToUserPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ShowCardDeckToUser(
          onClose: Get.back,
          onSelect: (int value) {
            Get.back();
            // further
          },
          userName: "Dharam",
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> waitingForUserToSelectCardsPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return WaitingForUserToSelectCards(
          onClose: Get.back,
          userName: "Dharam",
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> chosenCardsPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ChosenCards(
          onClose: Get.back,
          userName: "Dharam",
          userChosenCards: <DeckCardModel>[
            deckCardModel[0],
            deckCardModel[1],
            deckCardModel[2],
          ],
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> liveCarousalPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LiveCarousal(
          onClose: Get.back,
          userName: "Dharam",
          numOfSelection: 3,
          allCards: deckCardModel,
          onSelect: (List<DeckCardModel> selectedCards) {
            Get.back();
            // further
          },
        );
      },
    );
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<dynamic> list = jsonDecode(prefs.getString('tarot_cards') ?? "");
    for (var element in list) {
      deckCardModel.add(DeckCardModel.fromJson(element));
    }

    final SharedPreferenceService _pref = Get.put(SharedPreferenceService());
    for (var element in deckCardModel) {
      element.image = "${_pref.getAmazonUrl()}/${element.image}";
    }
  }
}
