import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/manage_dependency/controllers/manage_dependency_controller.dart';
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
      await showStatusDialog(title: 'Project Successfully Created');
    }
  }

  static Future<void> createModule({required String pageName}) async {
    showLoader();
    final bool status = await callTask(['create', 'page', pageName]);
    hideLoader();
    if (status) {
      await showStatusDialog(title: 'Module Successfully Created');
    }
  }

  static Future<void> createView(
      {required String viewName, required String moduleName}) async {
    showLoader();
    final bool status =
        await callTask(['create', 'view', viewName, 'on', moduleName]);
    hideLoader();
    if (status) {
      await showStatusDialog(title: 'View Successfully Created');
    }
  }

  static Future<void> createController(
      {required String controllerName, required String moduleName}) async {
    showLoader();
    final bool status = await callTask(
        ['create', 'controller', controllerName, 'on', moduleName]);
    hideLoader();
    if (status) {
      await showStatusDialog(title: 'Controller Successfully Created');
    }
  }

  static Future<void> createProvider(
      {required String providerName, required String moduleName}) async {
    showLoader();
    final bool status =
        await callTask(['create', 'provider', providerName, 'on', moduleName]);
    hideLoader();
    if (status) {
      await showStatusDialog(title: 'Provider Successfully Created');
    }
  }

  static Future<void> generateLocales(
      {required String destinationFolder}) async {
    showLoader();
    final bool status =
        await callTask(['generate', 'locales', destinationFolder]);
    if (status) {
      await showStatusDialog(title: 'Locales Successfully Generated');
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
      showStatusDialog(title: 'Model Successfully Generated');
    }
    hideLoader();
  }

  static Future<void> managePubspecPackage({
    required String packageName,
    required bool isRemoving,
    required bool isDev,
  }) async {
    print('debug print packageName $packageName');
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
      Get.find<ManageDependencyController>().loadPubSpecData();
      await showStatusDialog(
        title:
            'Dependency Successfully ${isRemoving ? 'Removed' : 'Installed'}',
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
      {required String title, String? content, bool isError = false}) async {
    await showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        icon: isError
            ? const Icon(
                Icons.error,
                color: Colors.red,
                size: 36,
              )
            : const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 36,
              ),
        content: Text(content ?? ''),
      ),
    );
  }
}
