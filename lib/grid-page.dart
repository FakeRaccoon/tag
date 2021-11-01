import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tag/Components/filter.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Controllers/item-controller.dart';
import 'package:tag/Grid/data-grid-source.dart';
import 'package:tag/Models/all-data-model.dart';
import 'package:tag/api-service.dart';
import 'package:tag/responsive.dart';

class GridPage extends StatefulWidget {
  @override
  _GridPageState createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  final ItemController item = Get.find();
  final dataController = Get.find<DataController>();

  Future<ItemDataSource> getItemDataSource() async {
    final response = await APIService().getAllTag(1);
    return ItemDataSource(response.data!);
  }

  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
        columnName: 'name',
        width: kIsWeb ? Get.width / 4 : Get.width / 2,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Nama Barang',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'status',
        width: kIsWeb ? Get.width / 8 : Get.width / 3,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'location',
        width: kIsWeb ? Get.width / 4 : Get.width / 2,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Lokasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'part',
        width: kIsWeb ? Get.width / 4 : Get.width / 2,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Part',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'diagnosis',
        width: kIsWeb ? Get.width / 4 : Get.width / 2,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Diagnosis',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'category',
        width: kIsWeb ? Get.width / 4 : Get.width / 2,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Kategori',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'merk',
        width: kIsWeb ? Get.width / 4 : Get.width / 2,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Merk',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'group',
        width: kIsWeb ? Get.width / 4 : Get.width / 2,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Group',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'List Barang',
            style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<AllDataModel>(
          future: APIService().getAllTag(1),
          builder: (BuildContext context, AsyncSnapshot<AllDataModel> snapshot) {
            if (snapshot.hasData) {
              item.itemDataSource.value = ItemDataSource(snapshot.data!.data!);
              return Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Filter(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('Total data ${item.itemDataSource.value.data.length}'),
                    ),
                    Expanded(
                      child: SfDataGrid(
                        source: item.itemDataSource.value,
                        onCellTap: (DataGridCellDetails value) {
                          if (value.rowColumnIndex.rowIndex > 0) {
                            int index = value.rowColumnIndex.rowIndex - 1;
                            kIsWeb
                                ? dataController.fetchDataWeb(item.itemDataSource.value.data[index].itemCode)
                                : dataController.fetchDataFromScan(item.itemDataSource.value.data[index].itemCode);
                          }
                        },
                        columns: getColumn(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      tablet: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<AllDataModel>(
          future: APIService().getAllTag(1),
          builder: (BuildContext context, AsyncSnapshot<AllDataModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Center(
                  child: Text('Tidak ada data'),
                );
              }
              item.itemDataSource.value = ItemDataSource(snapshot.data!.data!);
              return Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total data ${item.itemDataSource.value.data.length}'),
                    Expanded(
                      child: SfDataGrid(
                        source: item.itemDataSource.value,
                        onCellTap: (DataGridCellDetails value) {
                          if (value.rowColumnIndex.rowIndex > 0) {
                            int index = value.rowColumnIndex.rowIndex - 1;
                            kIsWeb
                                ? dataController.fetchDataWeb(item.itemDataSource.value.data[index].itemCode)
                                : dataController.fetchDataFromScan(item.itemDataSource.value.data[index].itemCode);
                          }
                        },
                        columns: getColumn(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      web: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<AllDataModel>(
          future: APIService().getAllTag(1),
          builder: (BuildContext context, AsyncSnapshot<AllDataModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Center(
                  child: Text('Tidak ada data'),
                );
              }
              item.itemDataSource.value = ItemDataSource(snapshot.data!.data!);
              return Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total data ${item.itemDataSource.value.data.length}'),
                    Expanded(
                      child: SfDataGrid(
                        frozenColumnsCount: 1,
                        source: item.itemDataSource.value,
                        onCellTap: (DataGridCellDetails value) {
                          if (value.rowColumnIndex.rowIndex > 0) {
                            int index = value.rowColumnIndex.rowIndex - 1;
                            dataController.fetchDataWeb(item.itemDataSource.value.data[index].itemCode);
                          }
                        },
                        columns: getColumn(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
