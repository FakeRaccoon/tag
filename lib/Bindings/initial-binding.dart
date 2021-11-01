import 'package:get/get.dart';
import 'package:tag/Controllers/initial-controller.dart';
import 'package:tag/Controllers/user-controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
    Get.put(InitialController());
  }
}
