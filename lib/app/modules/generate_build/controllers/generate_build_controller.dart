import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';

class GenerateBuildController extends GetxController {
  //TODO: Implement GenerateBuildController

  TextEditingController nameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  RxString defaultCommand = 'Android'.obs;

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

  Future<void> generateBuild() async {
    Task.showLoader();
    await Process.run(
      'Powershell.exe',
      [extractedCommand()],
      runInShell: false,
      //mode: ProcessStartMode.normal,
      includeParentEnvironment: true,
    );
    Task.hideLoader();
    Task.showStatusDialog(
      title: 'Build Generated Successfully',
      isSuccess: true,
    );
  }

  String extractedCommand() {
    switch (defaultCommand.value) {
      case 'Android':
        return 'flutter build apk';
      case 'iOS':
        return 'flutter build ipa';
      case 'Windows':
        return 'flutter build windows';
      default:
        return 'flutter build apk';
    }
  }
}
