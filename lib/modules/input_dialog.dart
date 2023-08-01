import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/data/app_repository.dart';
import 'package:getx_gui/modules/models/create_model.dart';

TextEditingController _inputController = TextEditingController();
TextEditingController _locationController = TextEditingController();

Future<String?> showInputDialog({required String title}) async {
  String? result;
  GlobalKey<FormState> formKey = GlobalKey();
  await showDialog(
    context: Get.context!,
    builder: (context) {
      return SimpleDialog(
        title: Text(title),
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: _inputController,
                    validator: (input) {
                      if (input?.isEmpty ?? false) {
                        return 'invalid input';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      result = _inputController.text.trim();
                      _inputController.clear();
                      Get.back();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
  return result;
}

Future<String?> showLocationDialog({required String title}) async {
  String? result;
  GlobalKey<FormState> formKey = GlobalKey();
  await showDialog(
    context: Get.context!,
    builder: (context) {
      return SimpleDialog(
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
                    title: TextFormField(
                      controller: _locationController,
                    ),
                    trailing: TextButton(
                      child: const Text('Choose'),
                      onPressed: () => _chooseFile(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      result = _locationController.text.trim();
                      _locationController.clear();
                      Get.back();
                    }
                  },
                  child: const Text('Next'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      );
    },
  );
  return result;
}

Future<String?> showInputDialogMenu(
    {required String title,
    required List<String> options,
    required String defaultOption}) async {
  String dropdownValue = defaultOption;
  await showDialog(
    context: Get.context!,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(title),
        children: [
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(
                      options.length,
                      (int index) {
                        return RadioListTile<String>(
                          value: options[index],
                          title: Text(options[index]),
                          groupValue: dropdownValue,
                          onChanged: (String? value) {
                            setState(() => dropdownValue = value!);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            },
          )
        ],
      );
    },
  );
  return dropdownValue;
}

_chooseFile() async {
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
