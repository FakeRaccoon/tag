import 'package:get/get.dart';
import 'package:tag/Controllers/login-controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
