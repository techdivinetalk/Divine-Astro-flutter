
import 'package:get/get.dart';
import 'package:speed_test_dart/classes/server.dart';
import 'package:speed_test_dart/speed_test_dart.dart';


class InternetSpeedController extends GetxController{

  SpeedTestDart tester = SpeedTestDart();
  List<Server> bestServersList = [];
  double downloadSpeed = 0.0;
  double uploadSpeed = 0.0;

  @override
  void onInit() {
    setBestServers();
  }

  Future<List<Server>> setBestServers() async {
    final settings = await tester.getSettings();
    final servers = settings.servers;


    final _bestServersList = await tester.getBestServers(
      servers: servers,
    );
      bestServersList = _bestServersList;
      return _bestServersList;
  }

   Future<double> getDownloadSpeed()async{
    final _downloadRate =
    await tester.testDownloadSpeed(servers: bestServersList);
    downloadSpeed = _downloadRate;
    update();
    return _downloadRate;
  }

   Future<double> getUploadSpeed()async{
    final _uploadSpeed =
    await tester.testUploadSpeed(servers: bestServersList);
    uploadSpeed = _uploadSpeed;
    update();
    return _uploadSpeed;
  }
}