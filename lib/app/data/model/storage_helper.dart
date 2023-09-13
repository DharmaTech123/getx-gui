import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:getx_gui/app/data/model/project_model.dart';

class AppStorage {
  static const String _key = 'projects';

  static void setData(dynamic value) => GetStorage().write(_key, value);

  static String? getString() {
    return GetStorage().read(_key);
  }

  static void clearData() async => GetStorage().erase();

  static void saveProject({required String title, required String location}) {
    List<ProjectModel> projects = getString() == null
        ? []
        : List<ProjectModel>.from(
            (jsonDecode(getString().toString()) as List<dynamic>).map(
              (model) => ProjectModel.fromJson(model),
            ),
          );
    if (projects.indexWhere((element) => element.location == location) == -1) {
      projects.add(ProjectModel(
        title: title,
        location: location,
      ));

      String encodedProjectList =
          jsonEncode(projects.map((model) => model.toJson()).toList())
              .toString();

      setData(encodedProjectList);
    }
  }

  static void removeProject({required String title, required String location}) {
    List<ProjectModel> projects = getString() == null
        ? []
        : List<ProjectModel>.from(
            (jsonDecode(getString().toString()) as List<dynamic>).map(
              (model) => ProjectModel.fromJson(model),
            ),
          );
    if (projects.indexWhere((element) => element.location == location) != -1) {
      projects.removeAt(
          projects.indexWhere((element) => element.location == location));

      String encodedProjectList =
          jsonEncode(projects.map((model) => model.toJson()).toList())
              .toString();

      setData(encodedProjectList);
    }
  }

  static List<ProjectModel>? retrieveProjects() {
    List<ProjectModel> projects = getString() == null
        ? []
        : List<ProjectModel>.from(
            (jsonDecode(getString().toString()) as List<dynamic>)
                .map<ProjectModel>(
              (model) => ProjectModel.fromJson(model),
            ),
          );
    return projects;
  }
}
