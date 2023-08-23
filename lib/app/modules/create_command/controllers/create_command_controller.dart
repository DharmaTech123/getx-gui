import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/root/models/create_model.dart';

class CreateCommandController extends GetxController {
  //TODO: Implement CreateCommandController

  RxString defaultCommand = CreateModel().createCommandList.first.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

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
