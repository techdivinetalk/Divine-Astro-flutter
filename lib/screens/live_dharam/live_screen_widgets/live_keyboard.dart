import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';

class LiveKeyboard extends StatefulWidget {
  const LiveKeyboard({required this.sendKeyboardMesage, super.key});
  final Function(String message) sendKeyboardMesage;

  @override
  State<LiveKeyboard> createState() => _LiveKeyboardState();
}

class _LiveKeyboardState extends State<LiveKeyboard> {
  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editingController.text = "";
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          autofocus: true,
          controller: _editingController,
          onChanged: (String value) {
            setState(() {});
          },
          onSubmitted: (String value) {
            sendKeyboardMesage();
          },
          cursorColor: appColors.yellow,
          style:  TextStyle(color: appColors.yellow),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            suffixIcon: _editingController.value.text == ""
                ? null
                : IconButton(
                    onPressed: sendKeyboardMesage,
                    icon: Image.asset(
                      "assets/images/live_send_message_new.png",
                      color: appColors.yellow,
                    ),
                  ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: appColors.white,
            hintText: "Say Hi",
            hintStyle:  TextStyle(color: appColors.yellow),
            border: OutlineInputBorder(
              borderSide:  BorderSide(
                width: 2,
                color: appColors.yellow,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(
                width: 2,
                color: appColors.yellow,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: appColors.yellow,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  void sendKeyboardMesage() {
    final String string = _editingController.value.text;
    widget.sendKeyboardMesage(string);
    return;
  }
}
