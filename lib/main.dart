import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tag/Bindings/auth-binding.dart';
import 'package:tag/Bindings/home-binding.dart';
import 'package:tag/Bindings/initial-binding.dart';
import 'package:tag/Bindings/login-binding.dart';
import 'package:tag/add-warehouse.dart';
import 'package:tag/data-edit-page.dart';
import 'package:tag/data-input-page.dart';
import 'package:tag/export-pdf.dart';
import 'package:tag/grid-page.dart';
import 'package:tag/home.dart';
import 'package:tag/item-list-page.dart';
import 'package:tag/log-page.dart';
import 'package:tag/login-page.dart';
import 'package:tag/root.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(behavior: MyBehavior(), child: child!);
      },
      title: 'Tag',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryIconTheme: IconThemeData(color: Colors.black),
        colorScheme: ColorScheme.light(primary: Colors.black54),
        primaryColor: Colors.black,
        splashColor: Colors.transparent,
        textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.black12),
      ),
      initialBinding: InitialBinding(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          binding: AuthBinding(),
          page: () => Root(),
        ),
        GetPage(
          name: '/login',
          binding: LoginBinding(),
          page: () => LoginPage(),
        ),
        GetPage(
          name: '/home',
          binding: HomeBinding(),
          page: () => Home(),
        ),
        GetPage(
          name: '/input',
          binding: HomeBinding(),
          page: () => DataInputPage(),
        ),
        GetPage(
          name: '/edit',
          binding: HomeBinding(),
          page: () => DataEditPage(),
        ),
        GetPage(
          name: '/warehouse',
          binding: HomeBinding(),
          page: () => AddWarehousePage(),
        ),
        GetPage(
          name: '/items',
          binding: HomeBinding(),
          page: () => ItemListPage(),
        ),
        GetPage(
          name: '/log',
          binding: HomeBinding(),
          page: () => LogPage(),
        ),
        GetPage(
          name: '/export',
          binding: HomeBinding(),
          page: () => ExportPdf(),
        ),
        GetPage(
          name: '/grid',
          // binding: HomeBinding(),
          page: () => GridPage(),
        ),
      ],
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
