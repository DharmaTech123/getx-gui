import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/data/app_colors.dart';
import 'package:getx_gui/modules/create_command_dialog.dart';
import 'package:getx_gui/modules/install_remove_dialog.dart';

import 'data/app_repository.dart';
import 'modules/generate_command_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp()); // starting point of app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.kEAEEE2,
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RxInt paneIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: AppColors.kDFE6D5,
              selectedIndex: paneIndex(),
              onDestinationSelected: (value) => paneIndex(value),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.create_new_folder),
                  selectedIcon: Icon(Icons.create_new_folder),
                  label: Text('Create'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sync),
                  selectedIcon: Icon(Icons.sync),
                  label: Text('Generate'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.install_desktop),
                  selectedIcon: Icon(Icons.install_desktop),
                  label: Text('Manage Package'),
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

  Container _buildBody() {
    return Container(
      child: isTaskRunning()
          ? const Center(child: CircularProgressIndicator())
          : _buildPaneBody(),
    );
  }

  Widget _buildPaneBody() {
    if (paneIndex.value == 1) {
      //return showCreateDialog(title: 'Create');
      return Create();
    } else if (paneIndex.value == 2) {
      //return showGenerateDialog(title: 'Generate');
      return Generate();
    } else if (paneIndex.value == 3) {
      //return showManagePackageDialog(title: 'Manage Package');
      return ManagePackage();
    } else {
      return const SizedBox.shrink();
    }
  }
}
