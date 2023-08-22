import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';

class StartUpController extends GetxController {
  //TODO: Implement StartUpController

  RxInt paneIndex = 0.obs;

  RxList<ProjectModel> projects = <ProjectModel>[].obs;

  TextEditingController searchProjectController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    projects(AppStorage.retrieveProjects() ?? []);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void filterList(String? value) {
    projects.
  }


}
