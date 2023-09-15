import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/unused_assets_detector.dart';
import 'package:getx_gui/app/data/model/pubspec_model.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/groot/common/utils/pubspec/pubspec_utils.dart';
import 'package:pubspec/pubspec.dart';

class ManageAssetsController extends GetxController {
  //TODO: Implement ManageAssetsController

  RxList<PubspecDirectory> fileSizes = <PubspecDirectory>[].obs;
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

  Future<void> readAssets() async {
    try {
      Task.showLoader();
      fileSizes.clear();
      Map<dynamic, dynamic>? assets =
          PubSpec.fromYamlString(File('pubspec.yaml').readAsStringSync())
              .unParsedYaml;
      if (assets != null) {
        if (assets['flutter'] != null) {
          if (assets['flutter']['assets'] != null) {
            var result = await PubspecModel.readAssets(
                assets['flutter']['assets'] as List);
            fileSizes(result);
            fileSizes.refresh();
          }
        }
      }
      Task.hideLoader();
    } catch (e) {
      Task.hideLoader();
      Get.rawSnackbar(message: e.toString());
    }
  }

  Future<void> showUnusedFile() async {
    Task.showLoader();
    await AssetsDetector.findUnusedAssets(
      fileSizes,
      '${Directory.current.path}\\lib',
    );
    Task.hideLoader();
    fileSizes.refresh();
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

  Future<void> deleteFile(File file) async {
    print('debug file ${file.path}');
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('debug file error $e');
      // Error in getting access to the file.
    }
  }

  String getFileSizeString({required int bytes, int decimals = 0}) {
    const List<String> suffixes = ['b', 'kb', 'mb', 'gb', 'tb'];
    if (bytes == 0) {
      return '0${suffixes[0]}';
    }
    final int i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  void showRemoveAssetsDialog(
      {required String path, required String fileName}) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete permanently ?'),
        content: Text('$fileName is not used'),
        actions: [
          TextButton(
            onPressed: () => _deleteAssetsAndReloadPubspec(path),
            child: const Text('Remove'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAssetsAndReloadPubspec(String path) async {
    Get.back();
    await deleteFile(File(path));
    Get.find<ManageAssetsController>().readAssets();
  }
}
