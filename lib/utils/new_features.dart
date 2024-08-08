// // import 'package:country_state_city/country_state_city.dart';
// import 'dart:async';
//
// import 'package:country_state_city/models/city.dart';
// import 'package:country_state_city/utils/city_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:speed_test_dart/classes/server.dart';
// import 'package:speed_test_dart/speed_test_dart.dart';
//
// import 'package:syncfusion_flutter_gauges/gauges.dart';
//
// class InternetConnectionTest extends StatefulWidget {
//   const InternetConnectionTest({super.key});
//
//   @override
//   State<InternetConnectionTest> createState() => _InternetSpeedTestState();
// }
//
// class _InternetSpeedTestState extends State<InternetConnectionTest> {
//   SpeedTestDart tester = SpeedTestDart();
//   List<Server> bestServersList = [];
//   var  selectedCity;
//
//   double downloadRate = 0;
//   double uploadRate = 0;
//   double _speedValue = 0;
//
//   bool readyToTest = false;
//   bool loading = false;
//
//   Future<void> setBestServers() async {
//     final settings = await tester.getSettings();
//     final servers = settings.servers;
//
//     final _bestServersList = await tester.getBestServers(
//       servers: servers,
//     );
//
//     setState(() {
//       bestServersList = _bestServersList;
//       readyToTest = true;
//     });
//   }
//
//   Future<void> _testSpeed() async {
//     setState(() {
//       loading = true;
//     });
//     final _downloadRate =
//     await tester.testDownloadSpeed(servers: bestServersList);
//     final _uploadRate = await tester.testUploadSpeed(servers: bestServersList);
//     setState(() {
//       uploadRate = _uploadRate;
//       downloadRate = _downloadRate;
//       _speedValue = downloadRate;
//       loading = false;
//     });
//   }
//
//
//   @override
//   void initState() {
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   setBestServers();
//     // })
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setBestServers();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.green),
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Internet Speed Tester'),
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SfRadialGauge(
//                     enableLoadingAnimation: true,
//                     animationDuration: 4500,
//                     axes: <RadialAxis>[
//                       RadialAxis(minimum: 0, maximum: 60, ranges: <GaugeRange>[
//                         GaugeRange(
//                             startValue: 0, endValue: 20, color: Colors.green),
//                         GaugeRange(
//                             startValue: 20, endValue: 40, color: Colors.orange),
//                         GaugeRange(
//                             startValue: 40, endValue: 60, color: Colors.red)
//                       ], pointers: <GaugePointer>[
//                         NeedlePointer(value: _speedValue)
//                       ], annotations: <GaugeAnnotation>[
//                         GaugeAnnotation(
//                             widget: Container(
//                                 child: Text(
//                                     "${_speedValue.toStringAsFixed(2)} Mb/s",
//                                     style: const TextStyle(
//                                         fontSize: 25,
//                                         fontWeight: FontWeight.bold))),
//                             angle: 90,
//                             positionFactor: 0.6)
//                       ])
//                     ]),
//                 const Text(
//                   'Test Upload speed:',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 if (loading)
//                   const Column(
//                     children: [
//                       CircularProgressIndicator(),
//                       SizedBox(height: 10),
//                       Text('Testing upload speed...'),
//                     ],
//                   )
//                 else
//                   Text('Upload rate ${uploadRate.toStringAsFixed(2)} Mb/s'),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 const Text(
//                   'Test Download Speed:',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 if (loading)
//                   const Column(
//                     children: [
//                       CircularProgressIndicator(),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text('Testing download speed...'),
//                     ],
//                   )
//                 else
//                   Text(
//                       'Download rate  ${downloadRate.toStringAsFixed(2)} Mb/s'),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: loading
//                       ? null
//                       : () async {
//                     if (!readyToTest || bestServersList.isEmpty) return;
//                     await _testSpeed();
//                   },
//                   child: const Text('Start'),
//                 ),
//                 const SizedBox(
//                   height: 200,
//                 ),
//
//                 FutureBuilder(
//                   future: getCountryCities("IN"),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.done) {
//
//                       final List<City> cities = snapshot.data ?? [];
//                       return DropdownButton(
//                         items: cities
//                             .map((e) => DropdownMenuItem(value:e.name,child: Text(e.name)))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCity = value;
//                           });
//                         },
//                         hint: Text('Select your city'),
//                         value: selectedCity,
//                       );
//                     }
//                     return const CircularProgressIndicator();
//                   },
//                 ),
//                 const SizedBox(
//                   height: 200,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
