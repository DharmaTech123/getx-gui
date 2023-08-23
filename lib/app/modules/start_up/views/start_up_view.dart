import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/create_project/views/create_project_view.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/create_command_view.dart';
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
                  icon: Icon(Icons.install_desktop),
                  selectedIcon: Icon(Icons.install_desktop),
                  label: Text('Projects'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.create_new_folder),
                  selectedIcon: Icon(Icons.create_new_folder),
                  label: Text('New Project'),
                ),
              ],
            ),
            VerticalDivider(thickness: 1.w, width: 1.w),
            Expanded(
              child: _buildPaneBody(),
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
            ],
          ),
          SizedBox(height: 30.h),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) => _buildProjectItem(index),
            itemCount: controller.projects.length,
          ),
        ],
      ),
    );
  }

  Widget _buildPaneBody() {
    if (controller.paneIndex.value == 0) {
      return _buildListProjects();
    } else if (controller.paneIndex.value == 1) {
      return CreateProjectView();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildProjectItem(int index) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Directory.current = controller.projects[index].location;
            currentWorkingDirectory(controller.projects[index].location);
            Get.offNamed(Routes.HOME);
          },
          horizontalTitleGap: 0,
          leading: const Icon(Icons.folder_copy_outlined),
          title: Text(
            controller.projects[index].title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
          subtitle: Text(
            controller.projects[index].location,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildRailLeading() {
    return Column(
      children: [
        SizedBox(height: 25.h),
        Row(
          children: [
            InkWell(
              onTap: () {
                AppStorage.clearData();
              },
              child: Text(
                'GETX UI',
                style: TextStyle(
                  fontSize: 34.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 25.h),
      ],
    );
  }
}
