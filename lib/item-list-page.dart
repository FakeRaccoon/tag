import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tag/Components/filter.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Controllers/item-controller.dart';
import 'package:tag/Models/all-data-model.dart';
import 'package:tag/api-service.dart';
import 'package:tag/responsive.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key}) : super(key: key);

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final ItemController item = Get.find();
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
        body: FutureBuilder(
          future: APIService().getAllTag(1),
          builder: (BuildContext context, AsyncSnapshot<AllDataModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.data!.isEmpty) {
                return Center(
                  child: Text('Tidak ada data'),
                );
              }
              item.data.value = snapshot.data!.data!;
              return Obx(
                () {
                  if (item.data.isEmpty) return Center(child: Text('Barang tidak ditemukan'));
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          // controller: item.scrollController,
                          // itemCount: item.hasMore.value ? item.data.length + 1 : item.data.length,
                          itemCount: item.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var status = {'status': 'Pending', 'color': 'red'};
                            // if (index != item.data.length)
                            switch (item.data[index].status) {
                              case 1:
                                status.assignAll({'status': 'Pending', 'color': '0xffFDC623'});
                                break;
                              case 2:
                                status.assignAll({'status': 'Approve', 'color': '0xff0CB017'});
                                break;
                              case 3:
                                status.assignAll({'status': 'Reject', 'color': '0xfff67897'});
                            }
                            // if (index == item.data.length) return _buildProgressIndicator();
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ExpandablePanel(
                                      header: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('d MMMM y').format(item.data[index].createdAt!),
                                            style: GoogleFonts.sourceSansPro(),
                                          ),
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                              Text(
                                                item.data[index].item!.itemName!,
                                                style: GoogleFonts.sourceSansPro(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                status['status']!,
                                                style: GoogleFonts.sourceSansPro(
                                                  color: Color(
                                                    int.parse(status['color']!),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      collapsed: Column(
                                        children: [],
                                      ),
                                      expanded: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text('Kategori'),
                                                  subtitle: Text(item.data[index].item!.category!.categoryName!),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text('Brand'),
                                                  subtitle: Text(item.data[index].item!.brand!.brandName!),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text('Group'),
                                                  subtitle: Text(item.data[index].item!.group!.groupName!),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  title: Text('Lokasi'),
                                                  subtitle: Text(
                                                    '${item.data[index].location!.warehouseName!} - ${item.data[index].location!.warehouseLocation!}',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text('Tipe'),
                                            subtitle: Text(item.data[index].type == 0 ? 'Trading' : 'Teknik'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text('Part Hilang / Rusak'),
                                      subtitle: Text(
                                        item.data[index].parts!.map((e) => e.partName).toList().join(', '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text('Diagnosa'),
                                      subtitle: Text(
                                        item.data[index].diagnoses!.map((e) => e.diagnosis).toList().join(', '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        height: 50,
                                        width: Get.width / 3,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          onPressed: () => dataController.fetchDataFromScan(
                                            item.data[index].itemCode,
                                          ),
                                          child: Text('Detail Barang'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return _buildProgressIndicator();
          },
        ),
      ),
      tablet: webItemList(),
      web: webItemList(),
    );
  }

  Scaffold webItemList() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: APIService().getAllTag(1),
        builder: (BuildContext context, AsyncSnapshot<AllDataModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.data!.isEmpty) {
              return Center(
                child: Text('Tidak ada data'),
              );
            }
            item.data.value = snapshot.data!.data!;
            return Obx(
              () {
                if (item.data.isEmpty)
                  return Center(
                    child: Text('Barang tidak ditemukan'),
                  );
                return ListView.builder(
                  controller: item.scrollController,
                  itemCount: item.hasMore.value ? item.data.length + 1 : item.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var status = {'status': 'Pending', 'color': 'red'};
                    switch (item.data[index].status) {
                      case 1:
                        status.assignAll({'status': 'Pending', 'color': '0xff222222'});
                        break;
                      case 2:
                        status.assignAll({'status': 'Approve', 'color': '0xff0CB017'});
                        break;
                      case 3:
                        status.assignAll({'status': 'Reject', 'color': '0xfff67897'});
                    }
                    if (index == item.data.length) return _buildProgressIndicator();
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('d MMMM y').format(item.data[index].createdAt!),
                              style: GoogleFonts.sourceSansPro(),
                            ),
                            Row(
                              children: [
                                Text(
                                  item.data[index].item!.itemName!,
                                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  status['status']!,
                                  style: GoogleFonts.sourceSansPro(
                                    color: Color(
                                      int.parse(status['color']!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text('Kategori'),
                                    subtitle: Text(item.data[index].item!.category!.categoryName!),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text('Brand'),
                                    subtitle: Text(item.data[index].item!.brand!.brandName!),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text('Group'),
                                    subtitle: Text(item.data[index].item!.group!.groupName!),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text('Lokasi'),
                                    subtitle: Text(
                                      '${item.data[index].location!.warehouseName!} - ${item.data[index].location!.warehouseLocation!}',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text('Tipe'),
                                    subtitle: Text(item.data[index].type == 0 ? 'Trading' : 'Teknik'),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                            ListTile(
                              title: Text('Part Hilang / Rusak'),
                              subtitle: Text(item.data[index].parts!.map((e) => e.partName).toList().join(', ')),
                            ),
                            ListTile(
                              title: Text('Diagnosa'),
                              subtitle: Text(item.data[index].diagnoses!.map((e) => e.diagnosis).toList().join(', ')),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                height: 50,
                                width: Get.width / 6,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () => dataController.fetchDataWeb(
                                    item.data[index].itemCode,
                                  ),
                                  child: Text('Detail Barang'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return _buildProgressIndicator();
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }
}
