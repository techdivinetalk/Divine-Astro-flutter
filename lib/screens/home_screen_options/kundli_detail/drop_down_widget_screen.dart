import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common_image_view.dart';
import '../../../common/custom_progress_dialog.dart';
import 'kundli_detail_controller.dart';

class ChalitChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const ChalitChartUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.chalitChart.value.data?.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.chalitChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.chalitChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class BrithChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const BrithChartUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.brithChart.value.data?.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.brithChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.brithChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class HoraChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const HoraChartUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.horaChart.value.data?.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.horaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.horaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class DreshkanChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const DreshkanChartUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.dreshkanChart.value.data?.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.dreshkanChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.dreshkanChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChathurthamashaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const ChathurthamashaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.chathurthamashChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.chathurthamashChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.chathurthamashChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class PanchmanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const PanchmanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.panchmanshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.panchmanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.panchmanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class SaptamanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const SaptamanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.saptamanshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.saptamanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.saptamanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class AshtamanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const AshtamanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.ashtamanshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.ashtamanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.ashtamanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class NavamanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const NavamanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.navamanshaChart.value.data?.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.navamanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.navamanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class DashamanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const DashamanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.dashamanshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.dashamanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.dashamanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class DwadashamshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const DwadashamshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.dwadashamshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.dwadashamshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.dwadashamshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class ShodashamshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const ShodashamshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.shodashamshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.shodashamshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.shodashamshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class VishamanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const VishamanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.vishamanshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.vishamanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.vishamanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChaturvimshamshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const ChaturvimshamshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.chaturvimshamshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild:
                  controller.chaturvimshamshaChart.value.data?.svg != null
                      ? Center(
                          child: CommonImageView(
                            imagePath:
                                "${controller.preference.getAmazonUrl()}/${controller.chaturvimshamshaChart.value.data!.svg}",
                            radius: BorderRadius.circular(10),
                            placeHolder: "assets/images/default_profile_2.png",
                            fit: BoxFit.cover,
                          ),
                        )
                      : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class BhamshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const BhamshaChartUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.bhamshaChart.value.data?.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.bhamshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.bhamshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class TrishamanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const TrishamanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.trishamanshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.trishamanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.trishamanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class KhavedamshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const KhavedamshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.khavedamshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.khavedamshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.khavedamshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class AkshvedanshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const AkshvedanshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.akshvedanshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.akshvedanshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.akshvedanshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}

class ShashtymshaChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const ShashtymshaChartUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  controller.shashtymshaChart.value.data?.svg == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              secondChild: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  KundliLoading(),
                ],
              ),
              firstChild: controller.shashtymshaChart.value.data?.svg != null
                  ? Center(
                      child: CommonImageView(
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.shashtymshaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile_2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
