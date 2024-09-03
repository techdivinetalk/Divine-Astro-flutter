import 'dart:async';

import 'package:flutter/material.dart';

class LiveEndedWidget extends StatefulWidget {
  final Function() init;
  final Function() callback;

  const LiveEndedWidget({
    super.key,
    required this.init,
    required this.callback,
  });

  @override
  State<LiveEndedWidget> createState() => _LiveEndedWidgetState();
}

class _LiveEndedWidgetState extends State<LiveEndedWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.init();
    _timer = Timer(const Duration(seconds: 3), () {
      widget.callback();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            "Live Ended",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Dear astrologer your live has ended",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
