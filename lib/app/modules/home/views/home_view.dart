import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/create_command/views/create_command_view.dart';
import 'package:getx_gui/app/modules/generate/views/generate_view.dart';
import 'package:getx_gui/app/modules/generate_build/views/generate_build_view.dart';
import 'package:getx_gui/app/modules/manage_assets/controllers/manage_assets_controller.dart';
import 'package:getx_gui/app/modules/manage_assets/views/manage_assets_view.dart';
import 'package:getx_gui/app/modules/manage_dependency/controllers/manage_dependency_controller.dart';
import 'package:getx_gui/app/modules/manage_dependency/views/manage_dependency_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/groot/common/utils/pubspec/pubspec_utils.dart';
import 'package:getx_gui/app/routes/app_pages.dart';
import 'package:path/path.dart' as p;

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  RxInt paneIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Row(
          children: [
            _buildNavigationRail(),
            //VerticalDivider(thickness: 1.w, width: 1.w),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  NavigationRail _buildNavigationRail() {
    return NavigationRail(
      useIndicator: true,
      selectedIndex: paneIndex(),
      extended: true,
      backgroundColor: AppColors.kF1F7F0,
      onDestinationSelected: (value) {
        Task.hideLoader();
        paneIndex(value);
        if (paneIndex.value == 5) {
          Get.offAllNamed(Routes.START_UP);
        }
      },
      selectedLabelTextStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      unselectedLabelTextStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      leading: _buildRailLeading(),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.create_new_folder_outlined),
          selectedIcon: Icon(Icons.create_new_folder_outlined),
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
        NavigationRailDestination(
          icon: Icon(Icons.build_circle_outlined),
          selectedIcon: Icon(Icons.build_circle_outlined),
          label: Text('Build'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.arrow_back),
          selectedIcon: Icon(Icons.arrow_back),
          label: Text('Exit'),
        ),
      ],
    );
  }

  Column _buildRailLeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        25.verticalSpace,
        Text(
          controller.projectName(),
          style: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.w600,
          ),
        ).paddingSymmetric(horizontal: 20),
        /*ChooseLocation(
          child: FittedBox(
            child: Text(
              controller.projectName(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
                //color: AppColors.k000000,
              ),
            ),
          ),
          onSubmit: (path) => openProjectAndReloadData(path),
        ),*/
        25.verticalSpace,
      ],
    );
  }

  void openProjectAndReloadData(String path) {
    try {
      Directory.current = path;
      currentWorkingDirectory(path);
      controller.projectName(p.basename(Directory.current.path));
      PubspecUtils().loadFile(File('pubspec.yaml'));
      Get.find<ManageAssetsController>().readAssets();
      Get.find<ManageDependencyController>().loadPubSpecData();
    } catch (e) {
    } finally {
      Task.hideLoader();
    }
  }

  Widget _buildBody() {
    return Column(
      children: [
        isTaskRunning()
            ? const Center(child: LinearProgressIndicator())
            : const SizedBox.shrink(),
        ListTile(
          tileColor: AppColors.kF1F7F0,
          contentPadding: REdgeInsets.all(8),
          title: Obx(
            () => Text(
              currentWorkingDirectory(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () => controller.flutterClean(),
                child: Text(
                  'Flutter Clean',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: AppColors.kffffff,
                  ),
                ),
              ),
              10.horizontalSpace,
              FilledButton(
                onPressed: () => controller.flutterPubGet(),
                child: Text(
                  'Flutter Pub Get',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: AppColors.kffffff,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: _buildPaneBody(),
        ),
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
    } else if (paneIndex.value == 4) {
      return GenerateBuildView();
    } else {
      return const SizedBox.shrink();
    }
  }
}
