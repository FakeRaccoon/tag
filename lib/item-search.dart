import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag/Controllers/data-controller.dart';
import 'package:tag/Controllers/user-controller.dart';

class ItemSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetX<DataController>(
      builder: (controller) {
        controller.query.value = query;
        if (controller.itemLoading.value) return Center(child: CircularProgressIndicator());
        if (controller.item.value.data!.isEmpty) return Center(child: Text('Data tidak ditemukan.'));
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.item.value.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                if (controller.isNewInput.value) {
                  controller.itemController.value.text = controller.item.value.data![index].itemName!;
                  controller.itemId.value = controller.item.value.data![index].id!;
                } else {
                  controller.itemController.value.text = controller.item.value.data![index].itemName!;
                  controller.addLog(
                      '${Get.find<UserController>().user.value.username} edit item dari ${controller.data.value.item!.itemName!} menjadi ${controller.item.value.data![index].itemName!}',
                      1);
                  controller.editData(
                    controller.currentCode.value,
                    controller.item.value.data![index].id,
                    controller.data.value.status,
                    controller.data.value.type,
                    controller.data.value.urgency,
                    controller.data.value.description,
                    controller.data.value.location!.id,
                  );
                }
                close(context, null);
              },
              title: Text(controller.item.value.data![index].itemName!),
              subtitle: Text(controller.item.value.data![index].itemAlias!),
              trailing: Text(controller.item.value.data![index].itemCode!),
            );
          },
        );
      },
    );
  }
}
