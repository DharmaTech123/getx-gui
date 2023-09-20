import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/unused_assets_detector.dart';
import 'package:getx_gui/app/data/model/pubspec_model.dart';
import 'package:path/path.dart' as p;
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';

import '../controllers/manage_assets_controller.dart';

class ManageAssetsView extends GetView<ManageAssetsController> {
  ManageAssetsView({Key? key}) : super(key: key);

  @override
  ManageAssetsController controller = Get.put(ManageAssetsController());

  @override
  Widget build(BuildContext context) => Obx(
        () => Scaffold(
          body: SizedBox(
            width: Get.width,
            height: Get.height,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image.asset('assets/apple_logo.png'),
                    _buildTitle(),
                    _buildAssetsList(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildAssetsList() => Obx(
        () => controller.fileSizes.isEmpty
            ? SizedBox(
                height: 300.h,
                child: const Center(
                  child: Text('Not Found'),
                ),
              )
            : Container(
                padding: REdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildDirectoryList(),
                ),
              ),
      );

  List<Widget> _buildDirectoryList() {
    return List.generate(
      controller.fileSizes.length,
      (int i) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDirectoryExpansionTile(i),
        ],
      ),
    );
  }

  ExpansionTile _buildDirectoryExpansionTile(int i) {
    return ExpansionTile(
      title: Text(
        controller.fileSizes[i].pubspecItemList[0].directory,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        controller.getFileSizeString(
          bytes: controller.fileSizes[i].getDirectorySize(),
          decimals: 2,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: REdgeInsets.symmetric(vertical: 20),
      children: _buildDirectoryFilesList(i),
    );
  }

  List<Widget> _buildDirectoryFilesList(int i) {
    return List.generate(
      controller.fileSizes[i].pubspecItemList.length,
      (int j) => SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                if (!controller.fileSizes[i].pubspecItemList[j].isUsed) {
                  controller.showRemoveAssetsDialog(
                    fileName:
                        controller.fileSizes[i].pubspecItemList[j].fileName,
                    path: p.join(
                      Directory.current.path,
                      controller.fileSizes[i].pubspecItemList[j].directory,
                      controller.fileSizes[i].pubspecItemList[j].fileName,
                    ),
                  );
                }
              },
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              minVerticalPadding: 0,
              visualDensity: VisualDensity.compact,
              dense: true,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.fileSizes[i].pubspecItemList[j].fileName,
                    style: controller.fileSizes[i].pubspecItemList[j].isUsed
                        ? null
                        : const TextStyle(color: Colors.red),
                  ),
                ],
              ),
              trailing: Text(
                controller.getFileSizeString(
                  bytes: controller.fileSizes[i].pubspecItemList[j].fileSize,
                  decimals: 2,
                ),
                style: controller.fileSizes[i].pubspecItemList[j].isUsed
                    ? null
                    : const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildTitle() => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25),
        title: Row(
          children: [
            const Text(
              'Assets',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () => controller.readAssets(),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        subtitle: Text(
          '${PubspecModel.totalUnused} unused',
          style: const TextStyle(color: Colors.red),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () {
                controller.isSorted.toggle();
                controller.sortBySize();
              },
              icon: Icon(
                controller.isSorted()
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_up_rounded,
              ),
              label: const Text(
                'Sort by size',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
}
