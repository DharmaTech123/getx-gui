import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
}
