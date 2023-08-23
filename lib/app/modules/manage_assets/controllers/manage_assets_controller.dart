import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/pubspec_model.dart';
import 'package:getx_gui/app/root/common/utils/pubspec/pubspec_utils.dart';

class ManageAssetsController extends GetxController {
  //TODO: Implement ManageAssetsController

  Map<dynamic, dynamic>? assets = PubspecUtils.pubSpec.unParsedYaml;
  RxList<PubspecDirectory> fileSizes = <PubspecDirectory>[].obs;
  final TextEditingController locationController = TextEditingController();
  RxBool isSorted = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (File('pubspec.yaml').existsSync()) {
      readAssets();
    } else {
      Get.rawSnackbar(message: 'pubspec.yaml not found');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
    print('debug print ${assets}');
    print('debug print ${assets!['flutter']}');
    print('debug print ${assets!['flutter']['assets']}');
    print('debug print ${fileSizes.length}');
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
}
