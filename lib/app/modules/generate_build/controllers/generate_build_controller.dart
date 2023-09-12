import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getx_gui/app/groot/common/menu/menu.dart';
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
    String command = await extractedCommand();
    print('debug print command $command');
    Task.showLoader();
    await Process.run(
      'Powershell.exe',
      [command],
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

  Future<String> extractedCommand() async {
    switch (defaultCommand.value) {
      case 'Android':
        return await _generateAndroidBuildCommand();
      case 'iOS':
        return 'flutter build ipa';
      case 'Windows':
        return 'flutter build windows';
      default:
        return 'flutter build apk';
    }
  }

  Future<String> _generateAndroidBuildCommand() async {
    final menu = Menu([
      'App Bundle',
      'APK',
    ], title: 'Select which type of build you want to generate ?');
    final type = await menu.choose();
    if (type.index == 1) {
      final menu = Menu([
        'Fat APK',
        'Split per ABI',
      ], title: 'Select which type of build you want to generate ?');
      final args = await menu.choose();
      if (args.index == 0) {
        return 'flutter build ${type.result.toLowerCase()}';
      } else if (args.index == 1) {
        return 'flutter build ${type.result.toLowerCase()} --split-per-abi';
      }
    }
    return 'flutter build ${type.result.replaceAll(' ', '').toLowerCase()}';
  }
}
