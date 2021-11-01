import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/api-service.dart';
import 'package:tag/root.dart';
import 'package:http/http.dart' as http;

import 'initial-controller.dart';

class LoginController extends GetxController {
  final UserController userController = Get.find();
  static InitialController authController = Get.find();
  final box = GetStorage();

  var loginCount = 0.obs;
  var webLoginCount = 0.obs;

  var isObscured = true.obs;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static var options = BaseOptions(
    baseUrl: '${authController.url.value}',
    sendTimeout: 5000,
    receiveTimeout: 5000,
    connectTimeout: 5000,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Method": "*",
      "Access-Control-Allow-Headers": "*",
    },
  );

  Dio dio = Dio();

  void cloudLogin(String username, String password) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final response = await dio.post('http://cloudamt.ddns.net:9999/api/users/login', data: {
        'username': username.trim(),
        'password': password.trim(),
      });
      await box.write('token', response.data['token']);
      Get.offAllNamed('/home');
    } on DioError catch (e) {
      Get.back();
      if (e.response!.statusCode == 401) {
        Get.defaultDialog(title: 'Gagal Login', middleText: 'Cek email dan password');
      } else {
        Get.defaultDialog(title: 'Connection Error', middleText: 'Cek koneksi');
      }
      print(e.response!.statusCode);
    }
  }

  void localLogin(String username, String password) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final response = await dio.post('http://192.168.0.251:8000/api/users/login', data: {
        'username': username.trim(),
        'password': password.trim(),
      });
      await box.write('token', response.data['token']);
      Get.offAllNamed('/home');
    } on DioError catch (e) {
      Get.back();
      if (e.response!.statusCode == 401) {
        Get.defaultDialog(title: 'Gagal Login', middleText: 'Cek email dan password');
      } else {
        Get.defaultDialog(title: 'Connection Error', middleText: 'Cek koneksi');
      }
      print(e.response!.statusCode);
    }
  }

  void checkConnection() async {
    try {
      final response = await dio.get('${authController.url.value}');
      print(response.data);
      login(usernameController.text, passwordController.text);
    } catch (e) {
      Get.defaultDialog(title: 'Gagal Login', middleText: 'Cek koneksi');
    }
  }

  void checkConnectionWeb() async {
    if (authController.url.value == 'http://cloudamt.ddns.net:9999') {
      cloudLogin(usernameController.text, passwordController.text);
    } else {
      localLogin(usernameController.text, passwordController.text);
    }
  }

  void login(username, password) {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    APIService().login(username, password).then((value) async {
      Get.back();
      await box.write('token', value['token']);
      Get.offAllNamed('/home');
    });
  }

  @override
  void onInit() {
    super.onInit();
    // debounce(loginCount, (_) => login(usernameController.text, passwordController.text));
    debounce(loginCount, (_) => checkConnection());
    debounce(webLoginCount, (_) => checkConnectionWeb());
  }
}
