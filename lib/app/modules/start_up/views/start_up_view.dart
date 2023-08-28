import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/create_project/views/create_project_view.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/components/create_command_view.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/start_up_controller.dart';

class StartUpView extends GetView<StartUpController> {
  StartUpView({Key? key}) : super(key: key);

  @override
  StartUpController controller = Get.put(StartUpController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: AppColors.kffffff,
              useIndicator: false,
              selectedIndex: controller.paneIndex(),
              onDestinationSelected: (value) {
                controller.paneIndex(value);
                if (controller.paneIndex.value == 0) {
                  controller.fetchProjects();
                }
              },
              extended: true,
              leading: _buildRailLeading(),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.folder_open),
                  selectedIcon: Icon(Icons.folder),
                  label: Text('Projects'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: Text('Learn GetX'),
                ),
              ],
            ),
            VerticalDivider(thickness: 1.w, width: 1.w),
            Expanded(
              child: Column(
                children: [
                  isTaskRunning()
                      ? const Center(child: LinearProgressIndicator())
                      : const SizedBox.shrink(),
                  Expanded(
                    child: _buildPaneBody(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildListProjects() {
    return Container(
      width: Get.width.w,
      height: Get.height.h,
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Search Projects',
                  controller: controller.searchProjectController,
                  validator: (input) {
                    if (input?.isEmpty ?? false) {
                      return 'invalid input';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.filterList(value);
                  },
                ),
              ),
              ChooseLocation(
                label: 'New Project',
                onSubmit: (path) {
                  controller.onclickNewProject();
                },
              ),
              ChooseLocation(
                label: 'Open',
                onSubmit: (path) {
                  Directory.current = path;
                  currentWorkingDirectory(path);
                  Get.offNamed(Routes.HOME);
                },
              ),
              TextButton(
                onPressed: () {
                  AppStorage.clearData();
                  controller.projects.clear();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) => _buildProjectItem(index),
              itemCount: controller.projects.length,
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildPaneBody() {
    if (controller.paneIndex.value == 0) {
      return _buildListProjects();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildProjectItem(int index) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            _openProject(index);
          },
          //horizontalTitleGap: 0,
          visualDensity: VisualDensity.compact,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.zero,
          titleAlignment: ListTileTitleAlignment.center,
          leading: Container(
            height: 30.h,
            width: 30.w,
            color: Colors.blueGrey,
            child: Center(
              child: Text(
                controller.projects[index].title[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
          title: Text(
            controller.projects[index].title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
          subtitle: Text(
            controller.projects[index].location,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  void _openProject(int index) {
    try {
      Directory.current = controller.projects[index].location;
      currentWorkingDirectory(controller.projects[index].location);
      Get.offNamed(Routes.HOME);
    } catch (e) {
      Get.rawSnackbar(
        message: e.toString(),
      );
    }
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
}
