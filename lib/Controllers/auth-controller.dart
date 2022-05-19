import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/api-service.dart';

class AuthController extends GetxController {
  final controller = Get.find<UserController>();

  void checkAuth() async {
    try {
      final user = await APIService().getUserDetail();
      controller.user.value = user!;
      Get.offAllNamed('/home');
    } catch (e) {
      Get.offAllNamed('/login');
    }
  }

  @override
  void onInit() {
    checkAuth();
    super.onInit();
  }
}
