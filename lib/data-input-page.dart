import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Models/warehouse-model.dart';
import 'package:tag/api-service.dart';
import 'package:tag/item-search.dart';
import 'package:tag/responsive.dart';

class DataInputPage extends StatefulWidget {
  const DataInputPage({Key? key}) : super(key: key);

  @override
  _DataInputPageState createState() => _DataInputPageState();
}

class _DataInputPageState extends State<DataInputPage> {
  final DataController find = Get.find();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController itemController = TextEditingController();
  TextEditingController warehouseController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int initialValue = 1;

  @override
  void initState() {
    super.initState();
    find.fetchWarehouse();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Data Input',
            style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: buildFutureBuilder(),
      ),
      tablet: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: SizedBox(),
          title: Text(
            'Data Input',
            style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Container(
            width: 1200,
            child: Row(
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(
                  flex: 2,
                  child: buildFutureBuilder(),
                ),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
      web: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: SizedBox(),
          title: Text(
            'Data Input',
            style: GoogleFonts.sourceSansPro(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Container(
            width: 1200,
            child: Row(
              children: [
                Flexible(flex: 1, child: Container()),
                Flexible(
                  child: buildFutureBuilder(),
                ),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<WarehouseModel>> buildFutureBuilder() {
    return FutureBuilder(
      future: APIService().getWarehouse(),
      builder: (BuildContext context, AsyncSnapshot<List<WarehouseModel>> snapshot) {
        if (snapshot.hasData)
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: find.itemController.value,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Isi nama barang';
                        }
                      },
                      onTap: () {
                        find.isNewInput.value = true;
                        showSearch(context: context, delegate: ItemSearch());
                      },
                      readOnly: true,
                      decoration: InputDecoration(labelText: 'Barang'),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                      items: snapshot.data!
                          .map((e) => DropdownMenuItem(value: e.id, child: Text(e.warehouseName!)))
                          .toList(),
                      value: initialValue,
                      onChanged: (value) {
                        setState(() {
                          initialValue = int.parse(value.toString());
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih lokasi';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Lokasi'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Isi deskripsi barang';
                        }
                      },
                      decoration: InputDecoration(labelText: 'Deskripsi'),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: Get.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            find.createData(descriptionController.text, initialValue);
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
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
