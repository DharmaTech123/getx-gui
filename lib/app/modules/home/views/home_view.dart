import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/modules/ui/components/create_command_view.dart';
import 'package:getx_gui/app/modules/ui/components/generate_command_view.dart';
import 'package:getx_gui/app/modules/ui/components/manage_assets_view.dart';
import 'package:getx_gui/app/modules/ui/components/manage_dependency.dart';

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
            NavigationRail(
              useIndicator: false,
              selectedIndex: paneIndex(),
              onDestinationSelected: (value) => paneIndex(value),
              extended: true,
              leading: _buildRailLeading(),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.create_new_folder),
                  selectedIcon: Icon(Icons.create_new_folder),
                  label: Text('Create'),
                  padding: EdgeInsets.only(bottom: 10),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.install_desktop),
                  selectedIcon: Icon(Icons.install_desktop),
                  label: Text('Manage Dependency'),
                  padding: EdgeInsets.only(bottom: 10),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sync),
                  selectedIcon: Icon(Icons.sync),
                  label: Text('Generate'),
                  padding: EdgeInsets.only(bottom: 10),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.image_outlined),
                  selectedIcon: Icon(Icons.image_outlined),
                  label: Text('Manage Assets'),
                  padding: EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Column _buildRailLeading() {
    return Column(
      children: [
        SizedBox(height: 25),
        Row(
          children: [
            IconButton(
              onPressed: () => Get.back<void>(),
              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
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

  Container _buildBody() {
    return Container(
      child: isTaskRunning()
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  leading: const Text(
                    'Working Directory',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Obx(
                    () => Text(
                      currentWorkingDirectory(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                ),
                const SizedBox(height: 10),
                Expanded(child: _buildPaneBody()),
              ],
            ),
    );
  }

  Widget _buildPaneBody() {
    if (paneIndex.value == 0) {
      //return showCreateDialog(title: 'Create');
      return Create();
    } else if (paneIndex.value == 1) {
      //return showGenerateDialog(title: 'Generate');
      return ManagePackage();
    } else if (paneIndex.value == 2) {
      //return showManagePackageDialog(title: 'Manage Package');
      return Generate();
    } else if (paneIndex.value == 3) {
      //return showManagePackageDialog(title: 'Manage Package');
      return ManageAssets();
    } else {
      return const SizedBox.shrink();
    }
  }
}
