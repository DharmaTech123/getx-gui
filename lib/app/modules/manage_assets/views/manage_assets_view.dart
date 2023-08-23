import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationInput(),
                  const SizedBox(height: 20),
                  _buildTitle(),
                  _buildAssetsList(),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      );

  Container _buildAssetsList() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            controller.fileSizes.length,
            (int i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                controller.fileSizes[i].pubspecItemList.length,
                (int j) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDirectoryName(j, i),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller
                            .fileSizes[i].pubspecItemList[j].fileName),
                        Text(
                          controller.getFileSizeString(
                            bytes: controller
                                .fileSizes[i].pubspecItemList[j].fileSize,
                            decimals: 2,
                          ),
                        )
                      ],
                    ).paddingSymmetric(horizontal: 30),
                  ],
                ).paddingSymmetric(vertical: 10),
              ),
            ),
          ),
        ),
      );

  ListTile _buildTitle() => ListTile(
        title: const Text(
          'Assets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: TextButton.icon(
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
      );

  ListTile _buildLocationInput() => ListTile(
        title: AppTextField(
          label: 'Select Project Location',
          controller: controller.locationController,
          validator: (String? input) {
            if (input?.isEmpty ?? false) {
              return 'invalid input';
            }
            return null;
          },
        ),
        trailing: ChooseLocation(
          onSubmit: (path) {
            controller.locationController.text = path ?? '';
            Directory.current = path;
            if (File('pubspec.yaml').existsSync()) {
              controller.readAssets();
            } else {
              Get.rawSnackbar(message: 'pubspec.yaml not found');
            }
          },
        ),
      );

  Column _buildDirectoryName(int j, int i) => Column(
        children: [
          j == 0
              ? Text(
                  controller.fileSizes[i].pubspecItemList[j].directory,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                )
              : const SizedBox.shrink(),
          j == 0 ? const SizedBox(height: 10) : const SizedBox.shrink(),
        ],
      );
}
