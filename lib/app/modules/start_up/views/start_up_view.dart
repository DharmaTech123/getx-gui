import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/local/app_images.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/create_project/views/create_project_view.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/routes/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;

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
            _buildNavigationRail(),
            // VerticalDivider(thickness: 1.w, width: 1.w),
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

  NavigationRail _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: controller.paneIndex(),
      backgroundColor: AppColors.kF1F7F0,
      onDestinationSelected: (value) {
        if (value == 0) {
          controller.paneIndex(value);
          controller.fetchProjects();
        } else if (value == 1) {
          controller.launchUrlWeb('https://pub.dev/documentation/get');
        }
      },
      extended: true,
      leading: _buildRailLeading(),
      useIndicator: true,
      selectedLabelTextStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      unselectedLabelTextStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.folder_open),
          selectedIcon: Icon(Icons.folder_open),
          label: Text('Projects'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info_outline),
          label: Text('Learn GetX'),
        ),
      ],
    );
  }

  Container _buildListProjects() {
    return Container(
      width: Get.width.w,
      height: Get.height.h,
      // padding: REdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            color: AppColors.kF1F7F0,
            padding: REdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Search Projects',
                    isSearch: true,
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
                20.horizontalSpace,
                ChooseLocation(
                  label: 'New Project',
                  onSubmit: (path) {
                    controller.onclickNewProject();
                  },
                ),
                10.horizontalSpace,
                ChooseLocation(
                  label: 'Open',
                  onSubmit: (path) {
                    Directory.current = path;
                    currentWorkingDirectory(path);
                    Get.offNamed(Routes.HOME);
                    AppStorage.saveProject(
                      title: p.basename(Directory.current.path),
                      location: Directory.current.path,
                    );
                  },
                ),
                10.horizontalSpace,
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 0) {
                      AppStorage.clearData();
                      controller.projects.clear();
                    }
                  },
                  itemBuilder: (BuildContext bc) {
                    return const [
                      PopupMenuItem(
                        value: 0,
                        child: Text("Clear All Projects"),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: REdgeInsets.symmetric(horizontal: 20),
              separatorBuilder: (context, index) => SizedBox(height: 10.h),
              itemBuilder: (context, index) => _buildProjectItem(index),
              itemCount: controller.projects.length,
            ),
          ),
          20.verticalSpace,
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
          //contentPadding: EdgeInsets.zero,
          titleAlignment: ListTileTitleAlignment.center,
          leading: Container(
            height: 35.h,
            width: 35.w,
            color: Theme.of(Get.context as BuildContext).primaryColor,
            child: Center(
              child: Text(
                controller.projects[index].title[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24.sp,
                ),
              ),
            ),
          ),
          title: Text(
            controller.projects[index].title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
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
          trailing: IconButton(
            onPressed: () => controller.showRemoveConfirmation(index),
            icon: const Icon(
              Icons.close,
              size: 18,
              color: Colors.black26,
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
        25.verticalSpace,
        SizedBox(
          height: 120.h,
          width: 120.w,
          child: AppImages.getxLogo,
        ),
        25.verticalSpace,
      ],
    );
  }
}
