import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag/api-service.dart';

class InitialController extends GetxController {
  // var url = "http://192.168.0.251:8000".obs;
  var url = "http://192.168.5.114:8000".obs;
  final box = GetStorage();

  setUrl() async {
    if (box.read('url') != null) {
      url.value = box.read('url');
    }
  }

  @override
  void onInit() {
    super.onInit();
    setUrl();
  }
}
