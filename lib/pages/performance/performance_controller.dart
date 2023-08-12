import 'package:get/get.dart';

class PerformanceController extends GetxController {
  var percentageSubTitle = <ScoreModelClass>[
    ScoreModelClass("Total user converted from first user offer."),
    ScoreModelClass("Total repeated orders out of total orders received."),
    ScoreModelClass(
        "Total online hours spent on application on chat and call ."),
    ScoreModelClass("Total duration spent on application over live session."),
    ScoreModelClass("Total revenue generated through product selling."),
    ScoreModelClass(
        "Total busy hours out of online hours when busy over consultation."),
  ].obs;

  var scoreList = <ScoreModelClass>[
    ScoreModelClass("conversionRate".tr),
    ScoreModelClass("repurchaseRate".tr),
    ScoreModelClass("onlineHours".tr),
    ScoreModelClass("liveHours".tr),
    ScoreModelClass("eCommerce".tr),
    ScoreModelClass("busyHours".tr),
  ].obs;

  var percentageList = <PercentageModelClass>[
    PercentageModelClass("0-7hrs", '0'),
    PercentageModelClass("7-14hrs", '10'),
    PercentageModelClass("14-21hrs", '20'),
    PercentageModelClass("21-28hrs ", '40'),
    PercentageModelClass("28-35hrs", '60'),
    PercentageModelClass("35-45hrs", '80'),
    PercentageModelClass("45+", '100'),
  ].obs;
}

class ScoreModelClass {
  String? scoreName;

  ScoreModelClass(this.scoreName);
}

class PercentageModelClass {
  String? name, score;

  PercentageModelClass(this.name, this.score);
}
