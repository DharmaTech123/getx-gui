import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:process_run/shell.dart';
import 'package:url_launcher/url_launcher.dart';

class StartUpController extends GetxController {
  //TODO: Implement StartUpController

  RxInt paneIndex = 0.obs;

  RxList<ProjectModel> projects = <ProjectModel>[].obs;
  RxList<ProjectModel> tempProjectsList = <ProjectModel>[].obs;

  TextEditingController searchProjectController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    fetchProjects();
  }

  void fetchProjects() {
    projects(AppStorage.retrieveProjects() ?? []);
    tempProjectsList(AppStorage.retrieveProjects() ?? []);
    projects.refresh();
    tempProjectsList.refresh();
  }

  Future<void> onclickNewProject() async {
    /*  Process.start(
      'Powershell.exe -NoProfile -ExecutionPolicy unrestricted',
      ['get create project'],
      runInShell: true,
      mode: ProcessStartMode.detached,
      //includeParentEnvironment: true,
    );*/
    //Process.runSync('Powershell.exe', ['get create project'], runInShell: true);
    //await run('get create project', runInShell: true);
    await Task.createProject();
    fetchProjects();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> launchUrlWeb(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void filterList(String? keyword) {
    List<ProjectModel> searchProjectsList = [];
    if (keyword?.isNotEmpty ?? false) {
      for (var element in tempProjectsList) {
        if (element.title.contains(keyword.toString())) {
          searchProjectsList.add(element);
        }
      }
      projects(searchProjectsList);
    } else if (keyword?.isEmpty ?? false) {
      //projects.clear();
      projects(AppStorage.retrieveProjects() ?? []);
      tempProjectsList(AppStorage.retrieveProjects() ?? []);
    }
  }

  void showRemoveConfirmation(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove project ?'),
        actions: [
          TextButton(
            onPressed: () {
              AppStorage.removeProject(
                title: projects[index].title,
                location: projects[index].location,
              );
              projects.removeAt(index);
              Get.back();
            },
            child: const Text('Remove'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
