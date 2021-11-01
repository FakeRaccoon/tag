import 'package:get/get.dart';
import 'package:tag/Controllers/auth-controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
