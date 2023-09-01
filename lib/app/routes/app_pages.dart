import 'package:get/get.dart';

import '../modules/create_command/bindings/create_command_binding.dart';
import '../modules/create_command/views/create_command_view.dart';
import '../modules/create_project/bindings/create_project_binding.dart';
import '../modules/create_project/views/create_project_view.dart';
import '../modules/generate/bindings/generate_binding.dart';
import '../modules/generate/views/generate_view.dart';
import '../modules/generate_build/bindings/generate_build_binding.dart';
import '../modules/generate_build/views/generate_build_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/manage_assets/bindings/manage_assets_binding.dart';
import '../modules/manage_assets/views/manage_assets_view.dart';
import '../modules/manage_dependency/bindings/manage_dependency_binding.dart';
import '../modules/manage_dependency/views/manage_dependency_view.dart';
import '../modules/start_up/bindings/start_up_binding.dart';
import '../modules/start_up/views/start_up_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.START_UP;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.START_UP,
      page: () => StartUpView(),
      binding: StartUpBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PROJECT,
      page: () => CreateProjectView(),
      binding: CreateProjectBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_COMMAND,
      page: () => CreateCommandView(),
      binding: CreateCommandBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_DEPENDENCY,
      page: () => ManageDependencyView(),
      binding: ManageDependencyBinding(),
    ),
    GetPage(
      name: _Paths.GENERATE,
      page: () => GenerateView(),
      binding: GenerateBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_ASSETS,
      page: () => ManageAssetsView(),
      binding: ManageAssetsBinding(),
    ),
    GetPage(
      name: _Paths.GENERATE_BUILD,
      page: () => GenerateBuildView(),
      binding: GenerateBuildBinding(),
    ),
  ];
}
