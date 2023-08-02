import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/components/app_button.dart';
import 'package:getx_gui/components/app_text_feild.dart';
import 'package:getx_gui/data/app_colors.dart';
import 'package:getx_gui/modules/common/utils/pubspec/pubspec_utils.dart';
import 'package:getx_gui/modules/models/generate_model.dart';
import 'package:getx_gui/modules/tasks_list.dart';

class ManagePackage extends StatefulWidget {
  ManagePackage({super.key});

  TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String? defaultCommand;
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text(
                      'Manage Dependency',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    tileColor: AppColors.kDFE6D5,
                    title: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          focusColor: Colors.transparent,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                  ),
                  const SizedBox(height: 25),
                  _buildManagePackageInputField(widget.formKey),
                  const SizedBox(height: 25),
                  Center(
                    child: AppButton(
                      onPressed: () => _onSubmitCreate(
                          widget.formKey, widget.defaultCommand),
                      title: 'Submit',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  ExpansionTile(
                    title: const Text('Dependencies'),
                    children: List.generate(
                      PubspecUtils.pubSpec.dependencies.length,
                      (index) => Text(
                        PubspecUtils.pubSpec.dependencies
                            .toString()
                            .split(',')[index],
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: const Text('Dev Dependencies'),
                    children: List.generate(
                      PubspecUtils.pubSpec.devDependencies.length,
                      (index) => Text(
                        PubspecUtils.pubSpec.devDependencies
                            .toString()
                            .split(',')[index],
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: const Text('Dependency Overrides'),
                    children: List.generate(
                      PubspecUtils.pubSpec.dependencyOverrides.length,
                      (index) => Text(
                        PubspecUtils.pubSpec.dependencyOverrides
                            .toString()
                            .split(',')[index],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSubmitCreate(
    GlobalKey<FormState> formKey,
    String? defaultCommand,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      Get.back();
      if (defaultCommand == null) {
      } else if (defaultCommand.toLowerCase() == 'install') {
        Task.managePubspecPackage(
            packageName: widget.nameController.text, isRemoving: false);
      } else if (defaultCommand.toLowerCase() == 'remove') {
        Task.managePubspecPackage(
            packageName: widget.nameController.text, isRemoving: true);
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
            trailing: TextButton(
              child: const Text('Choose'),
              onPressed: () => _chooseFile(),
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

  void _chooseFile() async {
    try {
      final String? selectedDirectory = await getDirectoryPath();
      if (selectedDirectory != null) {
        widget.locationController.text = selectedDirectory ?? '';
        Directory.current = selectedDirectory;
        return;
      }
    } catch (e) {}
  }
}
