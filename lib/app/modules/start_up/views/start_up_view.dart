import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/create_command_view.dart';
import 'package:getx_gui/app/routes/app_pages.dart';

import '../controllers/start_up_controller.dart';

class StartUpView extends GetView<StartUpController> {
  StartUpView({Key? key}) : super(key: key);

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
              onDestinationSelected: (value) => controller.paneIndex(value),
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
            const VerticalDivider(thickness: 1, width: 1),
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
      width: Get.width,
      height: Get.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          AppTextField(
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
              }),
          const SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildProjectItem(index),
            itemCount: controller.projects.length,
          ),
        ],
      ),
    );
  }

  Widget _buildPaneBody() {
    if (controller.paneIndex.value == 0) {
      //return showCreateDialog(title: 'Create');
      return _buildListProjects();
    } else if (controller.paneIndex.value == 1) {
      //return showGenerateDialog(title: 'Generate');
      return Create();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildProjectItem(int index) {
    return InkWell(
      onTap: () {
        Directory.current = controller.projects[index].location;
        currentWorkingDirectory(controller.projects[index].location);
        Get.toNamed(Routes.HOME);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.projects[index].title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            controller.projects[index].location,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Column _buildRailLeading() {
    return Column(
      children: [
        SizedBox(height: 25),
        Row(
          children: [
            Text(
              'GETX UI',
              style: TextStyle(
                fontSize: 34,
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
