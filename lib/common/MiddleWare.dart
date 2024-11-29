import "package:get/get.dart";




class MiddleWare {
  String currentPage = "";
  MiddleWare._();
  static final MiddleWare instance = MiddleWare._();

  void observer(Routing? routing) {
    currentPage = routing!.current;
    return;
  }
}