import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/data/local/app_colors.dart';
import 'package:getx_gui/modules/ui/components/create_command_view.dart';
import 'package:getx_gui/modules/ui/components/manage_dependency.dart';
import 'package:getx_gui/modules/ui/components/manage_assets_view.dart';

import 'data/repository/app_repository.dart';
import 'modules/ui/components/generate_command_view.dart';

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.k121212,
        primarySwatch: Colors.green,
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
              backgroundColor: AppColors.k101D1B,
              selectedIconTheme: const IconThemeData(color: AppColors.k00CAA5),
              useIndicator: false,
              selectedLabelTextStyle: const TextStyle(
                color: AppColors.k00CAA5,
                fontWeight: FontWeight.bold,
              ),
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
    return const Column(
      children: [
        SizedBox(height: 25),
        Text(
          'GETX UI',
          style: TextStyle(
            fontSize: 34,
            color: AppColors.k116D5C,
          ),
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
                  tileColor: AppColors.k252525,
                  leading: const Text(
                    'Working Directory',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.k00CAA5,
                    ),
                  ),
                  title: Text(
                    Directory.current.path,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.k00CAA5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                ),
                SizedBox(height: 10),
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
