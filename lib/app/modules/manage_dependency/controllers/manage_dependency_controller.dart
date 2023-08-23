import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/root/common/utils/pubspec/pubspec_utils.dart';
import 'package:getx_gui/app/root/models/generate_model.dart';

class ManageDependencyController extends GetxController {
  //TODO: Implement ManageDependencyController

  TextEditingController nameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  RxString defaultCommand = 'Install'.obs;
  RxBool isDev = false.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  var dependenciesList = PubspecUtils.pubSpec.dependencies;

  @override
  void onInit() {
    super.onInit();
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
