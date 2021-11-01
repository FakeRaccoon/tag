import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tag/Controllers/initial-controller.dart';
import 'package:tag/Controllers/data-controller.dart';

class ImagePreview extends StatefulWidget {
  final int index;

  const ImagePreview({Key? key, required this.index}) : super(key: key);
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  final DataController dataController = Get.find();
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: kIsWeb ? true : false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: kIsWeb ? Get.width / 2 : Get.width,
          height: kIsWeb ? Get.height : Get.width,
          child: PageView.builder(
            physics: kIsWeb ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
            controller: pageController,
            itemCount: dataController.data.value.images!.length,
            itemBuilder: (BuildContext context, int index) {
              return InteractiveViewer(
                child: Image.network(
                  '${Get.find<InitialController>().url}/storage/${dataController.data.value.images![index].url!}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, ImageChunkEvent? loading) {
                    if (loading == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loading.expectedTotalBytes != null
                            ? loading.cumulativeBytesLoaded / loading.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
