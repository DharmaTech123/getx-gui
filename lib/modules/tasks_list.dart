import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:log/data/get.dart';
import 'package:log/data/app_repository.dart';
import 'package:log/modules/create_command_dialog.dart';
import 'package:log/modules/generate_command_dialog.dart';
import 'package:log/modules/input_dialog.dart';
import 'package:log/modules/install_remove_dialog.dart';

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
    bool status = await callTask(['create', 'project']);
    hideLoader();
    if (status) {
      showStatusDialog(title: 'Project Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createModule({required String pageName}) async {
    showLoader();
    bool status = await callTask(['create', 'page', pageName]);
    hideLoader();
    if (status) {
      showStatusDialog(title: 'Module Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createView(
      {required String viewName, required String moduleName}) async {
    showLoader();
    bool status =
        await callTask(['create', 'view', viewName, 'on', moduleName]);
    hideLoader();
    if (status) {
      showStatusDialog(title: 'View Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createController(
      {required String controllerName, required String moduleName}) async {
    showLoader();
    bool status = await callTask(
        ['create', 'controller', controllerName, 'on', moduleName]);
    hideLoader();
    if (status) {
      showStatusDialog(
          title: 'Controller Successfully Created', isSuccess: true);
    }
  }

  static Future<void> createProvider(
      {required String providerName, required String moduleName}) async {
    showLoader();
    bool status =
        await callTask(['create', 'provider', providerName, 'on', moduleName]);
    hideLoader();
    if (status) {
      showStatusDialog(title: 'Provider Successfully Created', isSuccess: true);
    }
  }

  static Future<void> generateLocales(
      {required String destinationFolder}) async {
    showLoader();
    bool status = await callTask(['generate', 'locales', destinationFolder]);
    if (status) {
      showStatusDialog(
          title: 'Locales Successfully Generated', isSuccess: true);
    }
    hideLoader();
  }

  static Future<void> generateModel(
      {required String destinationFolder,
      required String moduleName,
      required String modelSource}) async {
    showLoader();
    bool status = await callTask([
      'generate',
      'model',
      'on',
      moduleName,
      modelSource,
      destinationFolder
    ]);
    if (status) {
      showStatusDialog(
          title: 'Locales Successfully Generated', isSuccess: true);
    }
    hideLoader();
  }

  static Future<void> managePubspecPackage({
    required String packageName,
    required bool isRemoving,
  }) async {
    showLoader();
    bool status =
        await callTask([isRemoving ? 'remove' : 'install', packageName]);
    if (status) {
      showStatusDialog(
          title: 'Locales Successfully Generated', isSuccess: true);
    }
    hideLoader();
  }

  static showLoader() {
    isTaskRunning(true);
  }

  static hideLoader() {
    isTaskRunning(false);
  }

  static Future<void> showStatusDialog(
      {required String title, required bool isSuccess}) async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          icon: Icon(
            isSuccess ? Icons.check_circle : Icons.close_rounded,
            color: isSuccess ? Colors.green : Colors.red,
          ),
        );
      },
    );
  }
}
