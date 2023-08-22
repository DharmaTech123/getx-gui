import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/ui/task_manager/task_manager.dart';
import 'package:path/path.dart' as p;

class Task {
  static Future<void> create() async {
    //await showCreateDialog(title: 'Create');
  }

  static Future<void> generate() async {
    //await showGenerateDialog(title: 'Generate');
  }

  static Future<void> managePackage() async {
    //await showManagePackageDialog(title: 'Manage Package');
  }

  static Future<void> createProject() async {
    showLoader();
    final bool status = await callTask(['create', 'project']);
    hideLoader();
    if (status) {
      AppStorage.saveProject(
          title: p.basename(Directory.current.path),
          location: Directory.current.path);
      await showStatusDialog(
          title: 'Project Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createModule({required String pageName}) async {
    showLoader();
    final bool status = await callTask(['create', 'page', pageName]);
    hideLoader();
    if (status) {
      await showStatusDialog(
          title: 'Module Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createView(
      {required String viewName, required String moduleName}) async {
    showLoader();
    final bool status =
        await callTask(['create', 'view', viewName, 'on', moduleName]);
    hideLoader();
    if (status) {
      await showStatusDialog(
          title: 'View Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createController(
      {required String controllerName, required String moduleName}) async {
    showLoader();
    final bool status = await callTask(
        ['create', 'controller', controllerName, 'on', moduleName]);
    hideLoader();
    if (status) {
      await showStatusDialog(
          title: 'Controller Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createProvider(
      {required String providerName, required String moduleName}) async {
    showLoader();
    final bool status =
        await callTask(['create', 'provider', providerName, 'on', moduleName]);
    hideLoader();
    if (status) {
      await showStatusDialog(
          title: 'Provider Successfully Created', isSuccess: true);
    }
  }

  static Future<void> generateLocales(
      {required String destinationFolder}) async {
    showLoader();
    final bool status =
        await callTask(['generate', 'locales', destinationFolder]);
    if (status) {
      await showStatusDialog(
          title: 'Locales Successfully Generated', isSuccess: true);
    }
    hideLoader();
  }

  static Future<void> generateModel(
      {required String destinationFolder,
      required String moduleName,
      required String modelSource}) async {
    showLoader();
    final bool status = await callTask([
      'generate',
      'model',
      'on',
      moduleName,
      modelSource,
      destinationFolder
    ]);
    if (status) {
      showStatusDialog(title: 'Model Successfully Generated', isSuccess: true);
    }
    hideLoader();
  }

  static Future<void> managePubspecPackage({
    required String packageName,
    required bool isRemoving,
    required bool isDev,
  }) async {
    showLoader();
    List<String> args = [
      isRemoving ? 'remove' : 'install',
      isRemoving ? packageName.split(':').first : packageName
    ];
    if (isDev) {
      args.add('--dev');
    }
    final bool status = await callTask(args);
    if (status) {
      await showStatusDialog(
        title:
            'Dependency Successfully ${isRemoving ? 'Removed' : 'Installed'}',
        isSuccess: true,
      );
    }
    hideLoader();
  }

  static void showLoader() {
    isTaskRunning(true);
  }

  static void hideLoader() {
    isTaskRunning(false);
  }

  static Future<void> showStatusDialog(
      {required String title, required bool isSuccess}) async {
    await showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        icon: Icon(
          isSuccess ? Icons.check_circle : Icons.close_rounded,
          color: isSuccess ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
