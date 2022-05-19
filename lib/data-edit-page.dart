import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tag/Controllers/initial-controller.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Controllers/user-controller.dart';
import 'package:tag/Models/warehouse-model.dart';
import 'package:tag/api-service.dart';
import 'package:tag/responsive.dart';

import 'image-preview.dart';
import 'item-search.dart';

class DataEditPage extends StatefulWidget {
  const DataEditPage({Key? key}) : super(key: key);

  @override
  _DataEditPageState createState() => _DataEditPageState();
}

class _DataEditPageState extends State<DataEditPage> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          elevation: 0,
          // iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Edit Data',
            style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: DataEditBody(),
      ),
      tablet: Container(
        width: Get.width / 2,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DataEditBody(),
          ),
        ),
      ),
      web: Container(
        width: Get.width / 3,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DataEditBody(),
          ),
        ),
      ),
    );
  }
}

class DataEditBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<DataController>(
      builder: (controller) {
        var status = {'status': 'Pending', 'color': '0xffFDC623'};
        var urgency = '';
        var type = '';
        switch (controller.data.value.status) {
          case 1:
            status.assignAll({'status': 'Pending', 'color': '0xffFDC623'});
            break;
          case 2:
            status.assignAll({'status': 'Approve', 'color': '0xff0CB017'});
            break;
          case 3:
            status.assignAll({'status': 'Reject', 'color': '0xfff67897'});
        }
        switch (controller.data.value.urgency) {
          case 1:
            urgency = 'Low';
            break;
          case 2:
            urgency = 'Medium';
            break;
          case 3:
            urgency = 'High';
        }
        switch (controller.data.value.type) {
          case 1:
            type = 'Trading';
            break;
          case 2:
            type = 'Teknik';
            break;
        }
        return ListView(
          padding: EdgeInsets.all(10),
          cacheExtent: 9999,
          children: [
            ListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                'Status',
                style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: Text(
                status['status']!,
                style: TextStyle(
                  color: Color(int.parse(status['color']!)),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10),
            MenuItem(
              title: 'Barang',
              icon: Icons.edit,
              onTap: () {
                controller.isNewInput.value = false;
                showSearch(context: context, delegate: ItemSearch());
                // showMaterialModalBottomSheet(context: context, builder: (context) => ItemBottomSheet());
              },
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama',
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    controller.data.value.item!.itemName!,
                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kategori',
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    controller.data.value.item!.category!.categoryName!,
                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Merk',
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    controller.data.value.item!.brand!.brandName!,
                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Grup',
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    controller.data.value.item!.group!.groupName!,
                    style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MenuItem(
              title: 'Deskripsi',
              listTileTitle: controller.data.value.description,
            ),
            SizedBox(height: 10),
            MenuItem(
              title: 'Lokasi',
              icon: Icons.edit,
              listTileTitle: controller.data.value.location!.warehouseName!,
              listTileSubtitle: controller.data.value.location!.warehouseLocation!,
              onTap: () => Get.dialog(
                WarehouseDialog(),
              ),
            ),
            SizedBox(height: 10),
            MenuItem(
              title: 'Tipe',
              icon: Icons.edit,
              onTap: () => Get.dialog(
                Dialog(
                  child: Container(
                    width: Get.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit Tipe',
                            style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: controller.data.value.type == 1 ? true : false,
                            onChanged: (value) {
                              controller.editData(
                                controller.currentCode.value,
                                controller.data.value.item!.id!,
                                controller.data.value.status,
                                value == true ? 1 : 0,
                                controller.data.value.urgency,
                                controller.data.value.description,
                                controller.data.value.location!.id,
                              );
                              controller.addLog(
                                  '${controller.user.user.value.username} edit tipe menjadi Trading pada item code ${controller.data.value.itemCode}',
                                  1);
                              Get.back();
                            },
                            title: Text('Trading'),
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: controller.data.value.type == 2 ? true : false,
                            onChanged: (value) {
                              controller.editData(
                                controller.currentCode.value,
                                controller.data.value.item!.id!,
                                controller.data.value.status,
                                value == true ? 2 : 0,
                                controller.data.value.urgency,
                                controller.data.value.description,
                                controller.data.value.location!.id,
                              );
                              controller.addLog(
                                  '${controller.user.user.value.username} edit tipe menjadi Teknik pada item code ${controller.data.value.itemCode}',
                                  1);
                              Get.back();
                            },
                            title: Text('Teknik'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              widget: controller.data.value.type != 0
                  ? ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(type),
                    )
                  : null,
            ),
            SizedBox(height: 10),
            MenuItem(
              title: 'Part Rusak / Hilang',
              icon: Icons.add,
              onTap: () => Get.dialog(PartBottomSheet()),
              widget: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.data.value.parts!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(controller.data.value.parts![index].partName!),
                    subtitle: Text(controller.data.value.parts![index].user!.name!),
                    trailing: Text(DateFormat('d MMM y').format(controller.data.value.parts![index].createdAt!)),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            MenuItem(
              title: 'Diagnosis',
              icon: Icons.add,
              onTap: () => Get.dialog(DiagnosisBottomSheet()),
              widget: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.data.value.diagnoses!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(controller.data.value.diagnoses![index].diagnosis!),
                    subtitle: Text(controller.data.value.diagnoses![index].user!.name!),
                    trailing: Text(DateFormat('d MMM y').format(controller.data.value.diagnoses![index].createdAt!)),
                  );
                },
              ),
            ),
            if (controller.userController.user.value.role! >= 3 || controller.userController.user.value.role! == 0)
              SizedBox(height: 10),
            if (controller.userController.user.value.role! >= 3 || controller.userController.user.value.role! == 0)
              MenuItem(
                title: 'Penanganan',
                icon: Icons.add,
                onTap: controller.data.value.treatments != null ? null : () => Get.dialog(TreatmentBottomSheet()),
                widget: controller.data.value.treatments != null
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(controller.data.value.treatments!.treatment!),
                        subtitle: Text(controller.data.value.treatments!.user!.name!),
                        trailing: Text(DateFormat('d MMM y').format(controller.data.value.treatments!.createdAt!)),
                      )
                    : null,
              ),
            if (controller.userController.user.value.role! == 0 || controller.userController.user.value.role! >= 3)
              SizedBox(height: 10),
            if (controller.userController.user.value.role! == 0 || controller.userController.user.value.role! >= 3)
              MenuItem(
                title: 'Urgency',
                icon: Icons.add,
                onTap: () => Get.dialog(
                  Dialog(
                    child: Container(
                      width: Get.width / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pilih Urgency',
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: controller.data.value.urgency == 3 ? true : false,
                              onChanged: (value) {
                                controller.editData(
                                  controller.currentCode.value,
                                  controller.data.value.item!.id!,
                                  controller.data.value.status,
                                  controller.data.value.type,
                                  value == true ? 3 : 0,
                                  controller.data.value.description,
                                  controller.data.value.location!.id,
                                );
                                controller.addLog(
                                    '${controller.user.user.value.username} edit urgency menjadi High pada item code ${controller.data.value.itemCode}',
                                    1);
                                Get.back();
                              },
                              title: Text('High'),
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: controller.data.value.urgency == 2 ? true : false,
                              onChanged: (value) {
                                controller.editData(
                                  controller.currentCode.value,
                                  controller.data.value.item!.id!,
                                  controller.data.value.status,
                                  controller.data.value.type,
                                  value == true ? 2 : 0,
                                  controller.data.value.description,
                                  controller.data.value.location!.id,
                                );
                                controller.addLog(
                                    '${controller.user.user.value.username} edit urgency menjadi Medium pada item code ${controller.data.value.itemCode}',
                                    1);
                                Get.back();
                              },
                              title: Text('Medium'),
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: controller.data.value.urgency == 1 ? true : false,
                              onChanged: (value) {
                                controller.editData(
                                  controller.currentCode.value,
                                  controller.data.value.item!.id!,
                                  controller.data.value.status,
                                  controller.data.value.type,
                                  value == true ? 1 : 0,
                                  controller.data.value.description,
                                  controller.data.value.location!.id,
                                );
                                controller.addLog(
                                    '${controller.user.user.value.username} edit urgency menjadi Low pada item code ${controller.data.value.itemCode}',
                                    1);
                                Get.back();
                              },
                              title: Text('Low'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                widget: controller.data.value.urgency != 0
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(urgency),
                      )
                    : null,
              ),
            if (controller.userController.user.value.role! == 0 || controller.userController.user.value.role! == 4)
              SizedBox(height: 10),
            if (controller.userController.user.value.role! == 0 || controller.userController.user.value.role! == 4)
              MenuItem(
                title: 'Approval',
                icon: Icons.add,
                onTap: () => Get.dialog(
                  Dialog(
                    child: Container(
                      width: Get.width / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Approval',
                              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: controller.data.value.status == 2 ? true : false,
                              onChanged: (value) {
                                controller.editData(
                                  controller.currentCode.value,
                                  controller.data.value.item!.id!,
                                  value == true ? 2 : 0,
                                  controller.data.value.type,
                                  controller.data.value.urgency,
                                  controller.data.value.description,
                                  controller.data.value.location!.id,
                                );
                                controller.addLog(
                                    '${controller.user.user.value.username} approve pada item code ${controller.data.value.itemCode}',
                                    1);
                                Get.back();
                              },
                              title: Text('Approve'),
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: controller.data.value.status == 3 ? true : false,
                              onChanged: (value) {
                                controller.editData(
                                  controller.currentCode.value,
                                  controller.data.value.item!.id!,
                                  value == true ? 3 : 0,
                                  controller.data.value.type,
                                  controller.data.value.urgency,
                                  controller.data.value.description,
                                  controller.data.value.location!.id,
                                );
                                controller.addLog(
                                    '${controller.user.user.value.username} reject pada item code ${controller.data.value.itemCode}',
                                    1);
                                Get.back();
                              },
                              title: Text('Reject'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                widget: controller.data.value.status != 1
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(status['status']!),
                      )
                    : null,
              ),
            SizedBox(height: 10),
            MenuItem(
              title: 'Foto',
              icon: kIsWeb ? null : Icons.add,
              onTap: controller.data.value.images!.length == 10 || kIsWeb
                  ? null
                  : () => showMaterialModalBottomSheet(context: context, builder: (context) => ImageBottomSheet()),
              widget: SizedBox(
                height: 100,
                child: ListView.builder(
                  cacheExtent: 9999,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.data.value.images!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Get.dialog(
                          ImagePreview(
                            index: index,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Image.asset('assets/images/basic.png'),
                          imageUrl:
                              '${dio.options.baseUrl.split('/api').first}/storage/${controller.data.value.images![index].url!}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            if (controller.data.value.status != 1 && controller.userController.user.value.role! <= 2)
              Obx(
                () => CheckboxListTile(
                  tileColor: Colors.white,
                  value: controller.done.value,
                  onChanged: (value) {
                    controller.editData(
                      controller.currentCode.value,
                      controller.data.value.item!.id!,
                      value == true ? 4 : controller.data.value.status,
                      controller.data.value.type,
                      controller.data.value.urgency,
                      controller.data.value.description,
                      controller.data.value.location!.id,
                    );
                    controller.addLog(
                        '${controller.user.user.value.username} reject pada item code ${controller.data.value.itemCode}',
                        1);
                  },
                  title: Text('Done', style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ),
          ],
        );
      },
    );
  }
}

class WarehouseDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataController controller = Get.find();
    return Dialog(
      child: Container(
        width: Responsive.isMobile(context) ? Get.width : Get.width / 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Gudang',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<WarehouseModel>>(
                  future: APIService().getWarehouse(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      controller.warehouse.value = snapshot.data!;
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) => ListTile(
                          onTap: () {
                            Get.back();
                            controller.editData(
                              controller.currentCode.value,
                              controller.data.value.item!.id!,
                              controller.data.value.status,
                              controller.data.value.type,
                              controller.data.value.urgency,
                              controller.data.value.description,
                              controller.warehouse[index].id,
                            );
                            controller.addLog(
                                '${Get.find<UserController>().user.value.username} edit lokasi dari ${controller.data.value.location!.warehouseName!} - ${controller.data.value.location!.warehouseLocation!} menjadi ${controller.warehouse[index].warehouseName} - ${controller.warehouse[index].warehouseLocation} pada item code ${controller.data.value.itemCode}',
                                1);
                          },
                          contentPadding: EdgeInsets.zero,
                          title: Text(controller.warehouse[index].warehouseName!),
                          subtitle: Text(controller.warehouse[index].warehouseLocation!),
                        ),
                        itemCount: controller.warehouse.length,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemBottomSheet extends StatefulWidget {
  @override
  _ItemBottomSheetState createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  TextEditingController itemController = TextEditingController();
  final DataController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: Responsive.isMobile(context) ? Get.width : Get.width / 3,
        child: Padding(
          padding: context.mediaQueryViewInsets,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Barang',
                  style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: itemController,
                  decoration: InputDecoration(labelText: 'Nama'),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {},
                    // onPressed: () {
                    //   Get.back();
                    //   controller.editData(
                    //     controller.currentCode.value,
                    //     itemController.text,
                    //     controller.data.value.description,
                    //     controller.data.value.location!.id,
                    //   );
                    // },
                    child: Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PartBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController partController = TextEditingController();
    final DataController controller = Get.find();
    return Dialog(
      child: Container(
        width: Responsive.isMobile(context) ? Get.width : Get.width / 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Part',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: partController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.addPart(controller.data.value.id, partController.text);
                  },
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiagnosisBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController diagnosisController = TextEditingController();
    final DataController controller = Get.find();
    return Dialog(
      child: Container(
        width: Responsive.isMobile(context) ? Get.width : Get.width / 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Diagnosis',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: diagnosisController,
                decoration: InputDecoration(labelText: 'Diagnosis'),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.addDiagnoses(controller.data.value.id, diagnosisController.text);
                  },
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController treatmentController = TextEditingController();
    final DataController controller = Get.find();
    return Dialog(
      child: Container(
        width: Responsive.isMobile(context) ? Get.width : Get.width / 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Penanganan',
                style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: treatmentController,
                decoration: InputDecoration(labelText: 'Penanganan'),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.addTreatment(controller.data.value.id, treatmentController.text);
                  },
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageBottomSheet extends StatefulWidget {
  const ImageBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _ImageBottomSheetState createState() => _ImageBottomSheetState();
}

class _ImageBottomSheetState extends State<ImageBottomSheet> {
  final DataController controller = Get.find();
  final ImagePicker picker = ImagePicker();
  File? croppedImage;

  void pickImage() async {
    final XFile? result = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (result != null) {
      setState(() {
        cropImage(result.path);
      });
    }
  }

  Future<Null> cropImage(source) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: source,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.white,
      ),
    );
    if (croppedFile != null) {
      setState(() {
        croppedImage = croppedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Foto',
              style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            croppedImage == null
                ? InkWell(
                    onTap: () => pickImage(),
                    child: Container(
                      height: Get.width,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  )
                : Container(
                    height: Get.width,
                    width: Get.width,
                    child: Image.file(
                      File(croppedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(height: 20),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  controller.uploadImage(croppedImage!);
                },
                child: Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.title,
    this.icon,
    this.listTileTitle,
    this.listTileSubtitle,
    this.onTap,
    this.widget,
  }) : super(key: key);
  final String title;
  final String? listTileTitle;
  final String? listTileSubtitle;
  final IconData? icon;
  final Function()? onTap;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: GoogleFonts.sourceSansPro(fontWeight: FontWeight.bold, fontSize: 20)),
                Spacer(),
                icon == null
                    ? SizedBox()
                    : IconButton(
                        onPressed: onTap,
                        icon: Icon(icon, size: 20),
                      ),
              ],
            ),
            if (listTileTitle != null && listTileSubtitle == null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(listTileTitle!),
              ),
            if (listTileTitle != null && listTileSubtitle != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(listTileTitle!),
                subtitle: Text(listTileSubtitle!),
              ),
            if (widget != null) widget!,
          ],
        ),
      ),
    );
  }
}
