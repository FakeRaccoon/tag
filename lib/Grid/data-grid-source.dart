import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tag/Models/all-data-model.dart';

class ItemDataSource extends DataGridSource {
  ItemDataSource(this.data) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Datum> data;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getBackgroundColor() {
      int index = dataGridRows.indexOf(row);
      if (data[index].status == 1) {
        return Color(0xffFFEB9D);
      } else if (data[index].status == 2) {
        return Color(0xffC7EECF);
      } else {
        return Color(0xffFFC7CE);
      }
    }

    Color getTextColor() {
      int index = dataGridRows.indexOf(row);
      if (data[index].status == 1) {
        return Color(0xffA28428);
      } else if (data[index].status == 2) {
        return Color(0xff5D975D);
      } else {
        return Color(0xffA53D46);
      }
    }

    return DataGridRowAdapter(
      color: getBackgroundColor(),
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(16.0),
          child: Text(
            e.value.toString(),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = data.map<DataGridRow>((e) {
      var status;
      switch (e.status) {
        case 1:
          status = "Pending";
          break;
        case 2:
          status = "Approve";
          break;
        case 3:
          status = "Reject";
          break;
      }
      return DataGridRow(
        cells: [
          DataGridCell(columnName: 'Nama Barang', value: e.item!.itemName),
          DataGridCell(columnName: 'Status', value: status),
          DataGridCell(columnName: 'Lokasi', value: '${e.location!.warehouseName} - ${e.location!.warehouseLocation}'),
          DataGridCell(columnName: 'Part', value: e.parts!.map((e) => e.partName).join(', ')),
          DataGridCell(columnName: 'Diagnosa', value: e.diagnoses!.map((e) => e.diagnosis).join(', ')),
          // DataGridCell(columnName: 'Penanganan', value: e.treatments!.treatment),
          DataGridCell(columnName: 'Kategori', value: e.item!.category!.categoryName),
          DataGridCell(columnName: 'Merk', value: e.item!.brand!.brandName),
          DataGridCell(columnName: 'Group', value: e.item!.group!.groupName),
        ],
      );
    }).toList(growable: false);
  }
}
