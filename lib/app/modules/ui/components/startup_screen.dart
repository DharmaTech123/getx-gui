import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/data/model/project_model.dart';
import 'package:getx_gui/app/data/model/storage_helper.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';
import 'package:getx_gui/app/routes/app_pages.dart';
import 'package:getx_gui/main.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  List<ProjectModel> projects = [];

  @override
  void initState() {
    super.initState();
    projects = AppStorage.retrieveProjects() ?? [];
    print('debug startup projects $projects');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Get.toNamed(Routes.HOME),
                  icon: const Icon(Icons.dashboard_outlined),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      projects = AppStorage.retrieveProjects() ?? [];
                      print('projects $projects');
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            SizedBox(height: 30),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) => _buildProjectItem(index),
              itemCount: projects.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectItem(int index) {
    return InkWell(
      onTap: () {
        Directory.current = projects[index].location;
        currentWorkingDirectory(projects[index].location);
        Get.toNamed(Routes.HOME);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            projects[index].title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            projects[index].location,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
