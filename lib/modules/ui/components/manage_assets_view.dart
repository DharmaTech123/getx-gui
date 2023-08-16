import 'dart:io';
import 'dart:math';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/data/models/pubspec_model.dart';
import 'package:getx_gui/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/modules/common/utils/pubspec/pubspec_utils.dart';

class ManageAssets extends StatefulWidget {
  ManageAssets({super.key});

  @override
  State<ManageAssets> createState() => _ManageAssetsState();
}

class _ManageAssetsState extends State<ManageAssets> {
  Map<dynamic, dynamic>? assets = PubspecUtils.pubSpec.unParsedYaml;

  RxList<PubspecDirectory> fileSizes = <PubspecDirectory>[].obs;
  final TextEditingController locationController = TextEditingController();
  RxBool isSorted = false.obs;

  @override
  void initState() {
    super.initState();
    if (File('pubspec.yaml').existsSync()) {
      readAssets();
    } else {
      Get.rawSnackbar(message: 'pubspec.yaml not found');
    }
  }

  void readAssets() {
    fileSizes.clear();
    if (assets != null) {
      if (assets!['flutter'] != null) {
        if (assets!['flutter']['assets'] != null) {
          fileSizes(PubspecModel.readAssets());
        }
      }
    }
  }

  void sortBySize() {
    for (PubspecDirectory dir in fileSizes) {
      dir.pubspecItemList.sort(
        (PubspecItem b, PubspecItem a) => isSorted()
            ? a.fileSize.compareTo(b.fileSize)
            : b.fileSize.compareTo(a.fileSize),
      );
    }
    fileSizes.refresh();
  }

  String getFileSizeString({required int bytes, int decimals = 0}) {
    const List<String> suffixes = ['b', 'kb', 'mb', 'gb', 'tb'];
    if (bytes == 0) {
      return '0${suffixes[0]}';
    }
    final int i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

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
            fileSizes.length,
            (int i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                fileSizes[i].pubspecItemList.length,
                (int j) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDirectoryName(j, i),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fileSizes[i].pubspecItemList[j].fileName),
                        Text(
                          getFileSizeString(
                            bytes: fileSizes[i].pubspecItemList[j].fileSize,
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: TextButton.icon(
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () {
            isSorted.toggle();
            sortBySize();
          },
          icon: Icon(
            isSorted()
                ? Icons.keyboard_arrow_down_rounded
                : Icons.keyboard_arrow_up_rounded,
          ),
          label: const Text(
            'Sort by size',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

  ListTile _buildLocationInput() => ListTile(
        //contentPadding: const EdgeInsets.symmetric(horizontal: 28),
        title: AppTextField(
          label: 'Select Project Location',
          controller: locationController,
          validator: (String? input) {
            if (input?.isEmpty ?? false) {
              return 'invalid input';
            }
            return null;
          },
        ),
        trailing: TextButton(
          child: const Text('Choose'),
          onPressed: () => _chooseFile(),
        ),
      );

  Column _buildDirectoryName(int j, int i) => Column(
        children: [
          j == 0
              ? Text(
                  fileSizes[i].pubspecItemList[j].directory,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                )
              : const SizedBox.shrink(),
          j == 0 ? const SizedBox(height: 10) : const SizedBox.shrink(),
        ],
      );

  Future<void> _chooseFile() async {
    try {
      final String? selectedDirectory = await getDirectoryPath();
      if (selectedDirectory != null) {
        locationController.text = selectedDirectory ?? '';
        Directory.current = selectedDirectory;
        if (File('pubspec.yaml').existsSync()) {
          readAssets();
        } else {
          Get.rawSnackbar(message: 'pubspec.yaml not found');
        }
        return;
      }
    } catch (e) {}
  }
}
