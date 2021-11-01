import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/api-service.dart';

import 'Models/warehouse-model.dart';

class AddWarehousePage extends StatefulWidget {
  const AddWarehousePage({Key? key}) : super(key: key);

  @override
  _AddWarehousePageState createState() => _AddWarehousePageState();
}

class _AddWarehousePageState extends State<AddWarehousePage> {
  final DataController find = Get.find();
  final UserController userController = Get.find();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController warehouseController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  int initialValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Gudang',
          style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: userController.user.value.role! <= 1
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: context.mediaQueryViewInsets,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: key,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: warehouseController,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Isi nama gudang';
                                  }
                                },
                                decoration: InputDecoration(labelText: 'Gudang'),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: locationController,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Isi lokasi gudang';
                                  }
                                },
                                decoration: InputDecoration(labelText: 'Lokasi'),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: Get.width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (key.currentState!.validate()) {
                                      find.createWarehouse(warehouseController.text, locationController.text);
                                    }
                                  },
                                  child: Text('Simpan'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : null,
      body: FutureBuilder(
        future: APIService().getWarehouse(),
        builder: (BuildContext context, AsyncSnapshot<List<WarehouseModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('Tidak ada data'),
              );
            }
            find.warehouse.value = snapshot.data!;
            return Obx(
              () => ListView.separated(
                itemCount: find.warehouse.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(find.warehouse[index].warehouseName!),
                    subtitle: Text(find.warehouse[index].warehouseLocation!),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
