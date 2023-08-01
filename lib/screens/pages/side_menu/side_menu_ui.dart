import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuDrawer extends StatelessWidget {
  const SideMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Version 0.0.0.0.0",
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close))
              ],
            ),
            ListTile(
              leading: Assets.images.icReport.image(),
              title: const Text('Report an Astrologer'),
              onTap: () => {},
            ),
            ListTile(
              leading: Assets.images.icSettings.image(),
              title: const Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icContactUs.image(),
              title: const Text('Contact Us'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icShareFeedback.image(),
              title: const Text('Share Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icImportContacts.image(),
              title: const Text('Important numbers'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Assets.images.icDonation.image(),
              title: const Text('Donation'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}
