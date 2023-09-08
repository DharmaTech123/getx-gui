import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/groot/models/generate_model.dart';

class GenerateController extends GetxController {
  //TODO: Implement GenerateController

  final TextEditingController nameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  RxString defaultCommand = GenerateModel().generateCommandList.first.obs;
  RxString modelSource = 'From Local'.obs;
  GlobalKey<FormState> formKey = GlobalKey();

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
