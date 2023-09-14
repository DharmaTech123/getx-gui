import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/groot/common/utils/pubspec/pubspec_utils.dart';
import 'package:getx_gui/app/groot/models/generate_model.dart';
import 'package:pubspec/pubspec.dart';

class ManageDependencyController extends GetxController {
  //TODO: Implement ManageDependencyController

  TextEditingController nameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  RxString defaultCommand = 'Install'.obs;
  RxBool isDev = false.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  PubSpec? pubSpec;

  @override
  void onInit() {
    super.onInit();
    loadPubSpecData();
  }

  void loadPubSpecData() {
    try {
      Task.showLoader();
      pubSpec = PubSpec.fromYamlString(File('pubspec.yaml').readAsStringSync());
      //pubSpec = PubspecUtils.pubSpec;
    } catch (e) {
      Task.hideLoader();
      pubSpec = null;
      Get.rawSnackbar(message: e.toString());
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
}
