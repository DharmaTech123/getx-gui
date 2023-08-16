import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/modules/ui/components/app_button.dart';
import 'package:getx_gui/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/data/repository/app_repository.dart';
import 'package:getx_gui/modules/models/create_model.dart';

TextEditingController _inputController = TextEditingController();
TextEditingController _locationController = TextEditingController();

Future<String?> showInputDialog({required String title}) async {
  String? result;
  GlobalKey<FormState> formKey = GlobalKey();
  await showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) => SimpleDialog(
      title: Text(title),
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: AppTextField(
                  controller: _inputController,
                  validator: (input) {
                    if (input?.isEmpty ?? false) {
                      return 'invalid input';
                    }
                    return null;
                  },
                  label: '',
                ),
              ),
              const SizedBox(height: 25),
              AppButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    result = _inputController.text.trim();
                    _inputController.clear();
                    Get.back<void>();
                  }
                },
                title: 'Submit',
              ),
            ],
          ),
        ),
      ],
    ),
  );
  return result;
}

Future<String?> showLocationDialog({required String title}) async {
  String? result;
  GlobalKey<FormState> formKey = GlobalKey();
  await showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) => SimpleDialog(
      title: Text(title),
      children: [
        Container(
          width: Get.width * 0.7,
          child: Column(
            children: [
              Form(
                key: formKey,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 50),
                  leading: const Text('Project Location'),
                  title: AppTextField(
                    controller: _locationController,
                  ),
                  trailing: TextButton(
                    child: const Text('Choose'),
                    onPressed: () => _chooseFile(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AppButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    result = _locationController.text.trim();
                    _locationController.clear();
                    Get.back<void>();
                  }
                },
                title: 'Next',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    ),
  );
  return result;
}

Future<String?> showInputDialogMenu(
    {required String title,
    required List<String> options,
    required String defaultOption}) async {
  String dropdownValue = defaultOption;
  await showDialog<void>(
    context: Get.context!,
    builder: (BuildContext context) => SimpleDialog(
      title: Text(title),
      children: [
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  options.length,
                  (int index) => RadioListTile<String>(
                    value: options[index],
                    title: Text(options[index]),
                    groupValue: dropdownValue,
                    onChanged: (String? value) {
                      setState(() => dropdownValue = value!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              AppButton(
                onPressed: () {
                  Get.back<void>();
                },
                title: 'Submit',
              ),
            ],
          ),
        )
      ],
    ),
  );
  return dropdownValue;
}

void _chooseFile() async {
  try {
    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      // Operation was canceled by the user.
      _locationController.text = selectedDirectory ?? '';
      Directory.current = selectedDirectory;
      return;
    }
  } catch (e) {}
}
