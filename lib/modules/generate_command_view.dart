import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/components/app_button.dart';
import 'package:getx_gui/components/app_text_feild.dart';
import 'package:getx_gui/data/app_colors.dart';
import 'package:getx_gui/modules/models/generate_model.dart';
import 'package:getx_gui/modules/tasks_list.dart';

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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 25),
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.kDFE6D5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            title: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  focusColor: Colors.transparent,
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
      Get.back();
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
            trailing: TextButton(
              child: const Text('Choose'),
              onPressed: () => _chooseFile(),
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
            trailing: TextButton(
              child: const Text('Choose'),
              onPressed: () => _chooseFile(),
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
            tileColor: AppColors.kDFE6D5,
            title: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  focusColor: Colors.transparent,
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          ),
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

Widget showGenerateDialog({required String title}) {
  String? defaultCommand;
  String? modelSource;
  GlobalKey<FormState> formKey = GlobalKey();
  //return _buildGenerateDialog(title, defaultCommand, formKey, modelSource);
  return SizedBox();
  /* showDialog(
    context: Get.context!,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return _buildGenerateDialog(title, defaultCommand, formKey, modelSource);
    },
  );*/
}
