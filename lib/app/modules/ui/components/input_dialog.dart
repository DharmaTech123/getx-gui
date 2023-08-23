import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';

TextEditingController _inputController = TextEditingController();

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
