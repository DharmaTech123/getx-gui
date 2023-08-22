import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/root/common/utils/pubspec/pubspec_utils.dart';
import 'package:pubspec/src/dependency.dart';

class ManagePackage extends StatefulWidget {
  ManagePackage({super.key});

  TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String? defaultCommand;
  bool isDev = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  State<ManagePackage> createState() => _ManagePackageState();
}

class _ManagePackageState extends State<ManagePackage> {
  var dependenciesList = PubspecUtils.pubSpec.dependencies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text(
                      'Manage Dependency',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    title: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          items: ['Install', 'Remove'].map(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() => widget.defaultCommand = value!);
                          },
                          hint: const Text('Select Command'),
                          value: widget.defaultCommand,
                          isDense: false,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                  ).paddingAll(25),
                  const SizedBox(height: 12),
                  _buildManagePackageInputField(widget.formKey),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Dev Dependency'),
                    value: widget.isDev,
                    onChanged: (value) =>
                        setState(() => widget.isDev = value ?? false),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: AppButton(
                      onPressed: () => _onSubmitCreate(
                          widget.formKey, widget.defaultCommand),
                      title: 'Submit',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildListDependencies(
                    title: 'Dependencies',
                    dependencies: PubspecUtils.pubSpec.dependencies,
                  ),
                  const SizedBox(height: 20),
                  _buildListDependencies(
                    title: 'Dev Dependencies',
                    dependencies: PubspecUtils.pubSpec.devDependencies,
                  ),
                  const SizedBox(height: 20),
                  _buildListDependencies(
                    title: 'Dependency Overrides',
                    dependencies: PubspecUtils.pubSpec.dependencyOverrides,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildListDependencies(
      {required String title,
      required Map<String, DependencyReference> dependencies}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            dependencies.length,
            (index) => ListTile(
              minVerticalPadding: 0,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 0,
              ),
              title: Text(
                dependencies
                    .toString()
                    .split(',')[index]
                    .replaceAll('{', '')
                    .replaceAll('}', '')
                    .trim(),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSubmitCreate(
    GlobalKey<FormState> formKey,
    String? defaultCommand,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      Get.back<void>();
      if (defaultCommand == null) {
      } else if (defaultCommand.toLowerCase() == 'install') {
        Task.managePubspecPackage(
            packageName: widget.nameController.text,
            isRemoving: false,
            isDev: widget.isDev);
      } else if (defaultCommand.toLowerCase() == 'remove') {
        Task.managePubspecPackage(
            packageName: widget.nameController.text,
            isRemoving: true,
            isDev: widget.isDev);
      }
      widget.locationController.clear();
      widget.nameController.clear();
      widget.destinationController.clear();
    }
  }

  Form _buildManagePackageInputField(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            title: AppTextField(
              label: 'Project Root Location',
              controller: widget.locationController,
              validator: (input) {
                if (input?.isEmpty ?? false) {
                  return 'invalid input';
                }
                return null;
              },
            ),
            trailing: ChooseLocation(
              onSubmit: (path) {
                setState(() {
                  widget.locationController.text = path ?? '';
                });
              },
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            title: AppTextField(
              label: 'Package Name',
              controller: widget.nameController,
              validator: (input) {
                if (input?.isEmpty ?? false) {
                  return 'invalid input';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
