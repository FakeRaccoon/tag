import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag/Controllers/filter-controller.dart';
import 'package:tag/responsive.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final controller = Get.put(FilterController());
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller.itemSearchControllerFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey[50]!,
                ),
              ),
              hintText: 'Cari Barang',
              suffixIcon: IconButton(
                onPressed: () {
                  controller.getDataFromSearch();
                },
                icon: Icon(Icons.search),
              ),
            ),
            onChanged: (val) {
              if (val.isNotEmpty) {
                controller.filterList.assignAll(['Semua Barang', 'Status']);
              } else {
                controller.filterList.assignAll([
                  'Semua Barang',
                  'Kategori',
                  'Merk',
                  'Fungsi',
                  'Status',
                ]);
              }
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownSearch(
                  selectedItem: controller.filterList[0],
                  mode: Mode.MENU,
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey[50]!,
                      ),
                    ),
                    hintText: 'Semua Barang',
                  ),
                  items: controller.filterList,
                  onChanged: (value) {
                    controller.filter.value = value as String;
                  },
                ),
              ),
              Obx(
                () {
                  if (controller.filter.value == 'Semua Barang') {
                    return SizedBox();
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: DropdownSearch(
                        showSearchBox: controller.filter.value == 'Status' ? false : true,
                        mode: Mode.MENU,
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.grey[50]!,
                            ),
                          ),
                          hintText: 'Pilih ${controller.filter.value}',
                        ),
                        items: controller.categoryList,
                        onChanged: (v) {
                          controller.subFilter.value = v as String;
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      tablet: webUI(),
      web: webUI(),
    );
  }

  Row webUI() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller.itemSearchControllerFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey[50]!,
                ),
              ),
              hintText: 'Cari Barang',
              suffixIcon: IconButton(
                onPressed: () {
                  controller.getDataFromSearch();
                },
                icon: Icon(Icons.search),
              ),
            ),
            onChanged: (val) {
              if (val.isNotEmpty) {
                controller.filterList.assignAll(['Semua Barang', 'Status']);
              } else {
                controller.filterList.assignAll([
                  'Semua Barang',
                  'Kategori',
                  'Merk',
                  'Fungsi',
                  'Status',
                ]);
              }
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: DropdownSearch(
            selectedItem: controller.filterList[0],
            mode: Mode.MENU,
            dropdownSearchDecoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey[50]!,
                ),
              ),
              hintText: 'Semua Barang',
            ),
            items: controller.filterList,
            onChanged: (value) {
              controller.filter.value = value as String;
            },
          ),
        ),
        Obx(
          () {
            if (controller.filter.value == 'Semua Barang') {
              return SizedBox();
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownSearch(
                  showSearchBox: controller.filter.value == 'Status' ? false : true,
                  mode: Mode.MENU,
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey[50]!,
                      ),
                    ),
                    hintText: 'Pilih ${controller.filter.value}',
                  ),
                  items: controller.categoryList,
                  onChanged: (v) {
                    controller.subFilter.value = v as String;
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
