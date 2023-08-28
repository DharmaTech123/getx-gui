import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/pubspec_model.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/root/common/utils/pubspec/pubspec_utils.dart';

class ManageAssetsController extends GetxController {
  //TODO: Implement ManageAssetsController

  RxList<PubspecDirectory> fileSizes = <PubspecDirectory>[].obs;
  RxBool isSorted = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (File('pubspec.yaml').existsSync()) {
      print('debug print abc ${PubspecUtils.pubSpec.unParsedYaml}');
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
    try {
      Task.showLoader();
      fileSizes.clear();
      Map<dynamic, dynamic>? assets = PubspecUtils.pubSpec.unParsedYaml;
      if (assets != null) {
        if (assets['flutter'] != null) {
          if (assets['flutter']['assets'] != null) {
            fileSizes(PubspecModel.readAssets());
            fileSizes.refresh();
          }
        }
      }
    } catch (e) {
      Task.hideLoader();
      Get.rawSnackbar(message: e.toString());
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
}
