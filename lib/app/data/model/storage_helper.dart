import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:getx_gui/app/data/model/project_model.dart';

class AppStorage {
  static const String _key = 'projects';

  static void setData(dynamic value) => GetStorage().write(_key, value);

  static String? getString() {
    try {
      return GetStorage().read(_key);
    } catch (e) {
      return null;
    }
  }

  static void clearData() async => GetStorage().erase();

  static void saveProject({required String title, required String location}) {
    print('saveProject ${getString()} $title $location');
    var pro = jsonDecode(getString() ?? '');
    List<ProjectModel> projects = getString() == null
        ? []
        : List<ProjectModel>.from(
            (jsonDecode(pro) as List<dynamic>).map(
              (model) => ProjectModel.fromJson(model),
            ),
          );
    projects.add(ProjectModel(
      title: title,
      location: location,
    ));

    String encodedProjectList = jsonEncode(
      jsonEncode(projects.map((model) => model.toJson()).toList()).toString(),
    );

    setData(encodedProjectList);
  }

  static List<ProjectModel>? retrieveProjects() {
    if (getString() == null) {
      return null;
    }
    print('debug print getString ${getString()}');
    var pro = jsonDecode(getString() ?? '');
    print('debug print jsonDecode getString $pro');
    print('debug print type of getString ${pro.runtimeType}');
    List<ProjectModel> projects = getString() == null
        ? []
        : List<ProjectModel>.from(
            (jsonDecode(pro) as List<dynamic>).map<ProjectModel>(
              (model) => ProjectModel.fromJson(model),
            ),
          );
    /*try {
      List<ProjectModel> projects = getString() == null
          ? []
          : List<ProjectModel>.from(
              jsonDecode(getString() ?? '').map(
                (model) => ProjectModel.fromJson(model),
              ),
            );
      return projects;
    } catch (e) {
      return null;
    }*/
    return projects;
  }
}
