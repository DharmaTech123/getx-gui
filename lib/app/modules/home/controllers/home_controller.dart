import 'dart:io';

import 'package:get/get.dart';
import 'package:getx_gui/app/groot/common/utils/logger/log_utils.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell_run.dart';
import 'package:url_launcher/url_launcher.dart';

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
    try {
      await run(
        'flutter clean',
        verbose: true,
        workingDirectory: Directory.current.path,
      );
      LogService.success('Flutter Clean Success');
      Task.hideLoader();
      Task.showStatusDialog(title: 'Flutter Clean Success');
    } on Exception catch (error) {
      LogService.error(error.toString());
    }
  }

  Future<void> flutterPubGet() async {
    Task.showLoader();
    try {
      await run(
        'flutter pub get',
        verbose: true,
        workingDirectory: Directory.current.path,
      );
      LogService.success('Got dependencies!');
      Task.hideLoader();
      Task.showStatusDialog(title: 'Got dependencies!');
    } on Exception catch (error) {
      LogService.error(error.toString());
    }
  }
}
