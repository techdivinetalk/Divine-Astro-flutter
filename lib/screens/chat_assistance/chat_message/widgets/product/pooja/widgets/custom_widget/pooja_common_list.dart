
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../common/colors.dart';
import '../../../../../../../../di/shared_preference_service.dart';
import '../../../../../../../live_dharam/widgets/custom_image_widget.dart';
import '../../pooja_dharam/get_pooja_addones_response.dart';

final SharedPreferenceService pref = Get.put(SharedPreferenceService());

class PoojaCommonList extends StatelessWidget {
  final List<GetPoojaAddOnesResponseData> list;
  final ScrollPhysics scrollPhysics;
  final void Function() onTap;

  PoojaCommonList({
    super.key,
    required this.list,
    required this.scrollPhysics,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      padding: EdgeInsets.zero,
      physics: scrollPhysics,
      itemBuilder: (BuildContext buildContext, int index) {
        final GetPoojaAddOnesResponseData item = list[index];
        final startPoint = pref.getAmazonUrl() ?? "";
        final endPoint = item.images ?? "";
        final String poojaImg = "$startPoint$endPoint";

        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: CustomImageWidget(
            imageUrl: poojaImg,
            rounded: false,
            typeEnum: TypeEnum.pooja,
          ),
          title: Text(
            item.name ?? "",
            style: TextStyle(color: appColors.black, fontSize: 16),
          ),
          subtitle: Text(
            "₹" "${item.amount ?? " "}",
            style: TextStyle(
              color: appColors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: item.isSelected,
              onChanged: (value) {
                item.isSelected = !item.isSelected;
                onTap();
              },
              activeColor: appColors.textColor,
            ),
          ),
          onTap: () {
            item.isSelected = !item.isSelected;
            onTap();
          },
        );
      },
    );
  }
}
