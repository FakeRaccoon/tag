import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tag/Components/filter.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Controllers/filter-controller.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/Models/user-model.dart';
import 'package:tag/api-service.dart';
import 'package:tag/grid-page.dart';
import 'package:tag/responsive.dart';
import 'package:tag/scan-barcode.dart';

import 'Controllers/item-controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserController userController = Get.find();
  final DataController data = Get.find();
  final put = Get.put(ItemController());

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetail?>(
      future: APIService().getUserDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userController.user.value = snapshot.data!;

          List<Widget> widgetList = [
            if (userController.user.value.role == 0)
              InkWell(
                onTap: () => Get.toNamed('/items'),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list),
                      Text('List Barang 2'),
                    ],
                  ),
                ),
              ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/warehouse');
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.house),
                    Text('Tambah Gudang'),
                  ],
                ),
              ),
            ),
            if (userController.user.value.role == 0 || userController.user.value.role! > 2)
              GestureDetector(
                onTap: () {
                  Get.toNamed('/grid');
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list),
                      Text('List Barang'),
                    ],
                  ),
                ),
              ),
          ];

          var role = 'No role';
          switch (userController.user.value.role) {
            case 0:
              role = 'Superuser';
              break;
            case 1:
              role = 'Gudang';
              break;
            case 2:
              role = 'Teknisi';
              break;
            case 3:
              role = 'Kepala Teknisi';
              break;
            case 4:
              role = 'Owner';
              break;
          }
          return Responsive(
            mobile: Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Tag App',
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  if (userController.user.value.role == 0)
                    IconButton(
                      color: Colors.black,
                      tooltip: 'Tambah User',
                      onPressed: () => Get.dialog(
                        RegisterDialog(),
                      ),
                      icon: Icon(Icons.person_add),
                    ),
                  if (userController.user.value.role == 0)
                    IconButton(
                      color: Colors.black,
                      tooltip: 'Log',
                      onPressed: () => Get.toNamed('/log'),
                      icon: Icon(Icons.list_alt_rounded),
                    ),
                  IconButton(
                    color: Colors.black,
                    onPressed: () {
                      Get.dialog(
                        Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Logout',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    APIService().logout().then((value) {
                                      Get.offAllNamed('/login');
                                    }, onError: (e) {});
                                  },
                                  child: Text('Logout'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.exit_to_app_rounded),
                  ),
                ],
              ),
              floatingActionButton: kIsWeb
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        Get.to(() => ScanPage());
                      },
                      child: Icon(Icons.qr_code_scanner_rounded),
                    ),
              body: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      child: Obx(
                        () => ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: 'Welcome, ',
                              style: GoogleFonts.sourceSansPro(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: userController.user.value.name,
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(role),
                        ),
                      ),
                    ),
                  ),
                  StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    crossAxisCount: 2,
                    itemCount: widgetList.length,
                    itemBuilder: (context, index) => Container(
                      height: Get.width / 2,
                      child: widgetList[index],
                    ),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  ),
                ],
              ),
            ),
            tablet: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Tag App',
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      userController.user.value.name!,
                      style: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      role,
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  if (userController.user.value.role == 0)
                    IconButton(
                      tooltip: 'Tambah User',
                      onPressed: () => Get.dialog(
                        RegisterDialog(),
                      ),
                      icon: Icon(Icons.person_add),
                    ),
                  if (userController.user.value.role == 0)
                    IconButton(
                      tooltip: 'Log',
                      onPressed: () => Get.toNamed('/log'),
                      icon: Icon(Icons.list_alt_rounded),
                    ),
                  IconButton(
                    onPressed: () {
                      Get.dialog(
                        Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Logout',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    APIService().logout().then((value) {
                                      Get.offAllNamed('/login');
                                    }, onError: (e) {});
                                  },
                                  child: Text('Logout'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.exit_to_app_rounded),
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  width: 1200,
                  child: Row(
                    children: [
                      // Flexible(
                      //   child: Align(
                      //     alignment: Alignment.topCenter,
                      //     child: ListView(
                      //       shrinkWrap: true,
                      //       children: [
                      //         MenuCard(
                      //           cardTitle: 'Menu',
                      //           menuList: [
                      //             {
                      //               'title': "List Barang",
                      //               'onTap': () => Get.toNamed('/items'),
                      //             },
                      //             {
                      //               'title': "Gudang",
                      //               'onTap': () => Get.toNamed('/warehouse'),
                      //             },
                      //           ],
                      //         ),
                      //         SizedBox(height: 10),
                      //         Card(
                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //           margin: EdgeInsets.symmetric(horizontal: 10),
                      //           child: Form(
                      //             key: key,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(20),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 mainAxisAlignment: MainAxisAlignment.center,
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Text(
                      //                     'Cek barang',
                      //                     style: GoogleFonts.sourceSansPro(
                      //                       fontWeight: FontWeight.bold,
                      //                       color: Color(0xff7c7c7c),
                      //                     ),
                      //                   ),
                      //                   SizedBox(height: 10),
                      //                   TextFormField(
                      //                     validator: (value) {
                      //                       if (value!.isEmpty) return 'isi kode barang';
                      //                       if (value.length < 5) return 'kode barang harus 5 karakter';
                      //                       return null;
                      //                     },
                      //                     controller: data.itemCodeController.value,
                      //                     decoration: InputDecoration(labelText: 'Kode Barang'),
                      //                   ),
                      //                   SizedBox(height: 20),
                      //                   SizedBox(
                      //                     width: Get.width,
                      //                     child: ElevatedButton(
                      //                       onPressed: () {
                      //                         if (key.currentState!.validate()) {
                      //                           data.fetchDataWeb(data.itemCodeController.value.text);
                      //                         }
                      //                       },
                      //                       child: Text('Cek Kode Barang'),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'List Barang',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Filter(),
                              SizedBox(height: 10),
                              Expanded(
                                child: GridPage(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            web: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Tag App',
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      userController.user.value.name!,
                      style: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      role,
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  if (userController.user.value.role == 0)
                    IconButton(
                      color: Colors.black,
                      tooltip: 'Tambah User',
                      onPressed: () => Get.dialog(
                        RegisterDialog(),
                      ),
                      icon: Icon(Icons.person_add),
                    ),
                  if (userController.user.value.role == 0)
                    IconButton(
                      color: Colors.black,
                      tooltip: 'Log',
                      onPressed: () => Get.toNamed('/log'),
                      icon: Icon(Icons.list_alt_rounded),
                    ),
                  IconButton(
                    color: Colors.black,
                    onPressed: () {
                      Get.dialog(
                        Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Logout',
                                  style: GoogleFonts.sourceSansPro(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    APIService().logout().then((value) {
                                      Get.offAllNamed('/login');
                                    }, onError: (e) {});
                                  },
                                  child: Text('Logout'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.exit_to_app_rounded),
                  ),
                ],
              ),
              body: Center(
                child: Container(
                  width: 1200,
                  child: Row(
                    children: [
                      // Flexible(
                      //   child: Align(
                      //     alignment: Alignment.topCenter,
                      //     child: ListView(
                      //       shrinkWrap: true,
                      //       children: [
                      //         MenuCard(
                      //           cardTitle: 'Menu',
                      //           menuList: [
                      //             {
                      //               'title': "List Barang",
                      //               'onTap': () => Get.toNamed('/items'),
                      //             },
                      //             {
                      //               'title': "Gudang",
                      //               'onTap': () => Get.toNamed('/warehouse'),
                      //             },
                      //           ],
                      //         ),
                      //         SizedBox(height: 10),
                      //         Card(
                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //           margin: EdgeInsets.symmetric(horizontal: 10),
                      //           child: Form(
                      //             key: key,
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(20),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 mainAxisAlignment: MainAxisAlignment.center,
                      //                 mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                   Text(
                      //                     'Cek barang',
                      //                     style: GoogleFonts.sourceSansPro(
                      //                       fontWeight: FontWeight.bold,
                      //                       color: Color(0xff7c7c7c),
                      //                     ),
                      //                   ),
                      //                   SizedBox(height: 10),
                      //                   TextFormField(
                      //                     validator: (value) {
                      //                       if (value!.isEmpty) return 'isi kode barang';
                      //                       if (value.length < 5) return 'kode barang harus 5 karakter';
                      //                       return null;
                      //                     },
                      //                     controller: data.itemCodeController.value,
                      //                     decoration: InputDecoration(labelText: 'Kode Barang'),
                      //                   ),
                      //                   SizedBox(height: 20),
                      //                   SizedBox(
                      //                     width: Get.width,
                      //                     child: ElevatedButton(
                      //                       onPressed: () {
                      //                         if (key.currentState!.validate()) {
                      //                           data.fetchDataWeb(data.itemCodeController.value.text);
                      //                         }
                      //                       },
                      //                       child: Text('Cek Kode Barang'),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'List Barang',
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Filter(),
                            SizedBox(height: 10),
                            Expanded(
                              child: GridPage(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Terjadi Kesalahan'),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class RegisterDialog extends StatefulWidget {
  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final data = Get.find<DataController>();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late int roleId;
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    usernameController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: kIsWeb ? Get.width / 3 : Get.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Register',
                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (v) {
                      if (v!.isEmpty) return 'isi nama';
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                    ),
                  ),
                  TextFormField(
                    validator: (v) {
                      if (v!.isEmpty) return 'isi username';
                    },
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextFormField(
                    validator: (v) {
                      if (v!.isEmpty) return 'isi password';
                    },
                    controller: passController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownSearch(
                    mode: Mode.MENU,
                    label: 'Role',
                    items: data.roleList,
                    onChanged: (value) {
                      roleId = data.roleList.indexWhere((element) => element == value) + 1;
                    },
                    validator: (v) {
                      if (v == null) return 'pilih role';
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          APIService().register(
                            nameController.text,
                            usernameController.text,
                            passController.text,
                            roleId,
                          );
                        }
                      },
                      child: Text('Add User'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
