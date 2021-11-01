import 'package:get/get.dart';
import 'package:tag/Controllers/data-controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DataController());
  }
}
