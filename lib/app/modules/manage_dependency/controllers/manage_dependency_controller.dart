import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:pubspec/pubspec.dart';
import 'package:dart_depcheck/dart_depcheck.dart';

class ManageDependencyController extends GetxController {
  //TODO: Implement ManageDependencyController

  TextEditingController nameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  RxString defaultCommand = 'Install'.obs;
  RxBool isDev = false.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  PubSpec? pubSpec;
  RxList<String> unusedDependencies = <String>[].obs;
  RxList<String> unusedDevDependencies = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPubSpecData();
  }

  Future<void> loadPubSpecData() async {
    try {
      Task.showLoader();
      pubSpec = PubSpec.fromYamlString(File('pubspec.yaml').readAsStringSync());
      //pubSpec = PubspecUtils.pubSpec;
      Task.hideLoader();
    } catch (e) {
      Task.hideLoader();
      pubSpec = null;
      Get.rawSnackbar(message: e.toString());
    }
    final (dep, devDep) = await DependencyChecker.check();
    unusedDependencies(dep.toList());
    unusedDevDependencies(devDep.toList());

    print('Unused dependencies: $unusedDependencies');
    print('Unused dev_dependencies: $unusedDevDependencies');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void showRemoveAssetsDialog(
      {required String packageName, required bool isDev}) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove package ?'),
        content: Text('$packageName is not used'),
        actions: [
          TextButton(
            onPressed: () =>
                _removePackage(packageName: packageName, isDev: isDev),
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

  Future<void> _removePackage(
      {required String packageName, required bool isDev}) async {
    Get.back();
    await Task.managePubspecPackage(
      packageName: packageName,
      isRemoving: true,
      isDev: isDev,
    );
  }
}
