import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:tag/api-service.dart';

class LoginController extends GetxController {
  final box = GetStorage();

  var loginCount = 0.obs;
  var webLoginCount = 0.obs;

  var isObscured = true.obs;

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  void login(String username, String password) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final response = await dio.post('/users/login', data: {
        'username': username.trim(),
        'password': password.trim(),
      });
      await box.write('token', response.data['token']);
      Get.offAllNamed('/home');
    } on DioError catch (e) {
      Get.back();
      if (e.response?.statusCode == 401) {
        Get.defaultDialog(title: 'Gagal Login', middleText: 'Cek email dan password');
        return;
      }
      Get.defaultDialog(title: 'Connection Error', middleText: 'Cek koneksi');
    }
  }

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    debounce(webLoginCount, (_) => login(usernameController.text, passwordController.text));
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
