import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:divine_astrologer/Newchat/ChatController.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new_outlined),
        title: Text('Chat - In Progress'),
        actions: [
          Icon(Icons.more_vert)
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.redAccent.shade100,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text('Wallet Balance - ₹${controller.walletBalance}')),
                Obx(() => Text('Joined Date - ${controller.joinedDate}')),
                Obx(() => Text('Last Consulted - ${controller.lastConsultedDate}')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                Chip(label: Text('Details')),
                Obx(() => Chip(label: Text('${controller.userDetails['name']}'))),
                Obx(() => Chip(label: Text('${controller.userDetails['dob']}'))),
                Obx(() => Chip(label: Text('${controller.userDetails['gender']}'))),
                Obx(() => Chip(label: Text('${controller.userDetails['time']}'))),
                Obx(() => Chip(label: Text('${controller.userDetails['location']}'))),
                Obx(() => Chip(label: Text('${controller.userDetails['status']}'))),
                Obx(() => Chip(label: Text('${controller.userDetails['issue']}'))),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('View Kundli'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
                  ),
                  title: Text('Hello'),
                  subtitle: Text('06:41 PM'),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
                  ),
                  title: Text('Hi'),
                  subtitle: Text('06:41 PM'),
                  trailing: Image.network('https://via.placeholder.com/150', width: 100, height: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Add'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Welcome Message'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Welcome Message'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type Something...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
