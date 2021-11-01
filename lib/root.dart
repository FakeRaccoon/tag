import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/api-service.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  // final UserController userController = Get.find();
  //
  // checkLoginStatus() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var token = sharedPreferences.getString('token');
  //   if (token == null) {
  //     Get.offAllNamed('/login');
  //   } else {
  //     APIService().getUserDetail().then((value) {
  //       userController.user.value = value;
  //       Get.offAllNamed('/home');
  //     }, onError: (e) {
  //       Get.offAllNamed('/login');
  //     });
  //   }
  // }

  @override
  void initState() {
    // checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tag App'),
          ],
        ),
      ),
    );
  }
}
