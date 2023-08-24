import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/create_command/views/create_command_view.dart';
import 'package:getx_gui/app/modules/generate/views/generate_view.dart';
import 'package:getx_gui/app/modules/manage_assets/views/manage_assets_view.dart';
import 'package:getx_gui/app/modules/manage_dependency/views/manage_dependency_view.dart';
import 'package:getx_gui/app/modules/ui/components/create_command_view.dart';
import 'package:getx_gui/app/modules/ui/components/generate_command_view.dart';
import 'package:getx_gui/app/modules/ui/components/manage_assets_view.dart';
import 'package:getx_gui/app/modules/ui/components/manage_dependency.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getx_gui/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  RxInt paneIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.offNamed(Routes.START_UP),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: ListTile(
            trailing: Obx(
              () => Text(
                currentWorkingDirectory(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ),
        body: Row(
          children: [
            NavigationRail(
              useIndicator: false,
              selectedIndex: paneIndex(),
              extended: true,
              onDestinationSelected: (value) => paneIndex(value),
              leading: _buildRailLeading(),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.create_new_folder),
                  selectedIcon: Icon(Icons.create_new_folder),
                  label: Text('Create'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.install_desktop),
                  selectedIcon: Icon(Icons.install_desktop),
                  label: Text('Manage Dependency'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sync),
                  selectedIcon: Icon(Icons.sync),
                  label: Text('Generate'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.image_outlined),
                  selectedIcon: Icon(Icons.image_outlined),
                  label: Text('Manage Assets'),
                ),
              ],
            ),
            VerticalDivider(thickness: 1.w, width: 1.w),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Column _buildRailLeading() {
    return Column(
      children: [
        SizedBox(height: 25.h),
        Text(
          'GETX UI',
          style: TextStyle(
            fontSize: 34.sp,
          ),
        ),
        SizedBox(height: 25.h),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        isTaskRunning()
            ? const Center(child: LinearProgressIndicator())
            : const SizedBox.shrink(),
        SizedBox(height: 10.h),
        Expanded(child: _buildPaneBody()),
      ],
    );
  }

  Widget _buildPaneBody() {
    if (paneIndex.value == 0) {
      return CreateCommandView();
    } else if (paneIndex.value == 1) {
      return ManageDependencyView();
    } else if (paneIndex.value == 2) {
      return GenerateView();
    } else if (paneIndex.value == 3) {
      return ManageAssetsView();
    } else {
      return const SizedBox.shrink();
    }
  }
}
