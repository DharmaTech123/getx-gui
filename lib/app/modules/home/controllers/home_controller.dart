import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:path/path.dart' as p;

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  RxString projectName = 'GETX UI'.obs;

  @override
  void onInit() {
    super.onInit();

    projectName(p.basename(Directory.current.path));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> flutterClean() async {
    Task.showLoader();
    await Process.run(
      'Powershell.exe',
      ['flutter clean'],
      runInShell: true,
      workingDirectory: Directory.current.path,
      //mode: ProcessStartMode.normal,
      includeParentEnvironment: true,
    );
    Task.hideLoader();
    Task.showStatusDialog(
      title: 'Flutter Clean Successful',
      isSuccess: true,
    );
  }

  Future<void> flutterPubGet() async {
    Task.showLoader();
    await Process.run(
      'Powershell.exe',
      ['flutter pub get'],
      runInShell: true,
      workingDirectory: Directory.current.path,
      //mode: ProcessStartMode.normal,
      includeParentEnvironment: true,
    );
    Task.hideLoader();
    Task.showStatusDialog(
      title: 'Got dependencies!',
      isSuccess: true,
    );
  }
}
