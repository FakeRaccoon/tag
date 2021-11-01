import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/Controllers/initial-controller.dart';
import 'package:tag/Controllers/login-controller.dart';
import 'package:tag/responsive.dart';

class LoginPage extends StatelessWidget {
  final LoginController find = Get.find();
  final InitialController auth = Get.find();
  final box = GetStorage();
  final GlobalKey<FormState> mobileKey = GlobalKey<FormState>();
  final GlobalKey<FormState> tabKey = GlobalKey<FormState>();
  final GlobalKey<FormState> webKey = GlobalKey<FormState>();

  setUrl(url) async {
    box.write('url', url);
    print(box.read('url'));
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: mobileKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) return 'isi username';
                      return null;
                    },
                    controller: find.usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  Obx(
                    () => TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return 'isi password';
                        return null;
                      },
                      obscureText: find.isObscured.value,
                      controller: find.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () => find.isObscured.toggle(),
                          icon: Icon(find.isObscured.value ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                    ),
                  ),
                  DropdownSearch(
                    mode: Mode.MENU,
                    items: ['Local', 'Cloud'],
                    onChanged: (value) {
                      if (value == 'Local') {
                        auth.url.value = 'http://192.168.0.251:8000';
                        // auth.url.value = 'http://192.168.0.251:8000';
                        setUrl('http://192.168.0.251:8000');
                        // setUrl('http://192.168.0.251:8000');
                      } else {
                        auth.url.value = 'http://cloudamt.ddns.net:9999';
                        setUrl('http://cloudamt.ddns.net:9999');
                      }
                    },
                    validator: (value) {
                      if (value == null) return 'isi koneksi';
                    },
                    dropdownSearchDecoration: InputDecoration(labelText: 'Koneksi'),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (mobileKey.currentState!.validate()) {
                          find.webLoginCount.value++;
                        }
                      },
                      child: Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      tablet: Scaffold(
        body: Center(
          child: Container(
            width: 1200,
            child: Row(
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: tabKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Login',
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: find.usernameController,
                              decoration: InputDecoration(labelText: 'Username'),
                            ),
                            Obx(
                              () => TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) return 'isi password';
                                },
                                obscureText: find.isObscured.value,
                                controller: find.passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => find.isObscured.toggle(),
                                    icon: Icon(find.isObscured.value ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                            DropdownSearch(
                              mode: Mode.MENU,
                              items: ['Local', 'Cloud'],
                              onChanged: (value) {
                                if (value == 'Local') {
                                  auth.url.value = 'http://192.168.0.251:8000';
                                  setUrl('http://192.168.0.251:8000');
                                } else {
                                  auth.url.value = 'http://cloudamt.ddns.net:9999';
                                  setUrl('http://cloudamt.ddns.net:9999');
                                }
                              },
                              validator: (value) {
                                if (value == null) return 'isi koneksi';
                              },
                              dropdownSearchDecoration: InputDecoration(labelText: 'Koneksi'),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (tabKey.currentState!.validate()) {
                                    find.webLoginCount.value++;
                                  }
                                },
                                child: Text('Login'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
      web: Scaffold(
        body: Center(
          child: Container(
            width: 1200,
            child: Row(
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: webKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Login',
                              style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) return 'isi username';
                              },
                              controller: find.usernameController,
                              decoration: InputDecoration(labelText: 'Username'),
                            ),
                            Obx(
                              () => TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) return 'isi password';
                                },
                                obscureText: find.isObscured.value,
                                controller: find.passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => find.isObscured.toggle(),
                                    icon: Icon(find.isObscured.value ? Icons.visibility_off : Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                            DropdownSearch(
                              mode: Mode.MENU,
                              items: ['Local', 'Cloud'],
                              onChanged: (value) {
                                if (value == 'Local') {
                                  auth.url.value = 'http://192.168.0.251:8000';
                                  setUrl('http://192.168.0.251:8000');
                                } else {
                                  auth.url.value = 'http://cloudamt.ddns.net:9999';
                                  setUrl('http://cloudamt.ddns.net:9999');
                                }
                              },
                              validator: (value) {
                                if (value == null) return 'isi koneksi';
                              },
                              dropdownSearchDecoration: InputDecoration(labelText: 'Koneksi'),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: Get.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (webKey.currentState!.validate()) {
                                    find.webLoginCount.value++;
                                  }
                                },
                                child: Text('Login'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
