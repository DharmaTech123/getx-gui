import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/groot/models/generate_model.dart';

class Generate extends StatefulWidget {
  Generate({super.key});

  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  String? defaultCommand;
  String? modelSource;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  State<Generate> createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            title: Text(
              'Generate',
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
                  items: GenerateModel().generateCommandList.map(
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
          _buildInputTextFieldWidgets(
            widget.defaultCommand,
            widget.formKey,
            setState,
          ),
          const SizedBox(height: 12),
          Center(
            child: AppButton(
              onPressed: () => _onSubmitCreate(
                widget.formKey,
                widget.defaultCommand,
              ),
              title: 'Submit',
            ),
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
      Get.back<void>();
      if (defaultCommand == null) {
      } else if (defaultCommand.toLowerCase() ==
          GenerateCommandName.locales.name) {
        Task.generateLocales(
            destinationFolder: widget.destinationController.text);
      } else if (defaultCommand.toLowerCase() ==
          GenerateCommandName.model.name) {
        if (widget.modelSource != null) {
          Task.generateModel(
            moduleName: widget.nameController.text,
            modelSource:
                widget.modelSource!.contains('From Local') ? 'with' : 'from',
            destinationFolder: widget.destinationController.text,
          );
        }
      }
      widget.locationController.clear();
      widget.nameController.clear();
      widget.destinationController.clear();
    }
  }

  Widget _buildInputTextFieldWidgets(
    String? defaultCommand,
    GlobalKey<FormState> formKey,
    StateSetter setState,
  ) {
    if (defaultCommand == null) {
      return const SizedBox.shrink();
    } else if (defaultCommand.toLowerCase() ==
        GenerateCommandName.locales.name) {
      return _buildGenerateLocaleInputField(formKey);
    } else if (defaultCommand.toLowerCase() == GenerateCommandName.model.name) {
      return _buildGenerateModelInputField(formKey, setState);
    }
    return const SizedBox.shrink();
  }

  Form _buildGenerateLocaleInputField(GlobalKey<FormState> formKey) {
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
              label: 'directory with your translation files in json format',
              controller: widget.destinationController,
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

  Form _buildGenerateModelInputField(
    GlobalKey<FormState> formKey,
    StateSetter setState,
  ) {
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
              label: 'Module Name',
              controller: widget.nameController,
              validator: (input) {
                if (input?.isEmpty ?? false) {
                  return 'invalid input';
                }
                return null;
              },
            ),
          ),
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
                  items: ['From Local', 'From Network'].map(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.modelSource = value!;
                    });
                  },
                  hint: const Text('From'),
                  value: widget.modelSource,
                  isDense: false,
                ),
              ),
            ),
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
          ).paddingAll(25),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            title: AppTextField(
              label: 'path of your template file in json format',
              controller: widget.destinationController,
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
