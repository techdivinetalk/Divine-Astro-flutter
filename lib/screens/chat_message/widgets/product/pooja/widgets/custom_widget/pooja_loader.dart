import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../common/colors.dart';

class PoojaLoader extends StatelessWidget {
  const PoojaLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate:
          const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7,crossAxisSpacing: 20,mainAxisSpacing: 20),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            highlightColor: appColors.grey.withOpacity(0.4),
            baseColor: appColors.grey.withOpacity(0.2),
            child: Container(
              width: 100,
              height: 150,
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
