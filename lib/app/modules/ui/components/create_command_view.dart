import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/root/models/create_model.dart';

class Create extends StatefulWidget {
  Create({super.key});

  String? defaultCommand;
  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  title: Text(
                    'Create',
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
                        items: CreateModel()
                            .createCommandList
                            .map(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
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
                    widget.defaultCommand, widget.formKey),
                const SizedBox(height: 12),
                Center(
                  child: AppButton(
                    onPressed: () =>
                        _onSubmitCreate(widget.formKey, widget.defaultCommand),
                    title: 'Submit',
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  void _onSubmitCreate(GlobalKey<FormState> formKey, String? defaultCommand) {
    if (formKey.currentState?.validate() ?? false) {
      Get.back<void>();
      if (defaultCommand == null) {
      } else if (defaultCommand.toLowerCase() ==
          CreateCommandName.project.name) {
        Task.createProject();
      } else if (defaultCommand.toLowerCase() == CreateCommandName.page.name) {
        Task.createModule(pageName: widget.nameController.text);
      } else if (defaultCommand.toLowerCase() ==
          CreateCommandName.controller.name) {
        Task.createController(
          controllerName: widget.nameController.text,
          moduleName: widget.destinationController.text,
        );
      } else if (defaultCommand.toLowerCase() == CreateCommandName.view.name) {
        Task.createView(
          viewName: widget.nameController.text,
          moduleName: widget.destinationController.text,
        );
      } else if (defaultCommand.toLowerCase() ==
          CreateCommandName.provider.name) {
        Task.createProvider(
          providerName: widget.nameController.text,
          moduleName: widget.destinationController.text,
        );
      }
      widget.locationController.clear();
      widget.nameController.clear();
      widget.destinationController.clear();
    }
  }

  Widget _buildInputTextFieldWidgets(
      String? defaultCommand, GlobalKey<FormState> formKey) {
    if (defaultCommand == null) {
      return const SizedBox.shrink();
    } else if (defaultCommand.toLowerCase() == CreateCommandName.project.name) {
      return _buildProjectInputField(formKey);
    } else if (defaultCommand.toLowerCase() == CreateCommandName.page.name) {
      return _buildPageInputField(formKey);
    } else if ((defaultCommand.toLowerCase() ==
            CreateCommandName.controller.name) ||
        (defaultCommand.toLowerCase() == CreateCommandName.view.name) ||
        (defaultCommand.toLowerCase() == CreateCommandName.provider.name)) {
      return _buildProviderInputField(formKey, defaultCommand);
    }
    return const SizedBox.shrink();
  }

  Form _buildProviderInputField(
    GlobalKey<FormState> formKey,
    String defaultCommand,
  ) =>
      Form(
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
                label: '$defaultCommand Name',
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 28),
              title: AppTextField(
                label: 'Module Name',
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

  Form _buildPageInputField(GlobalKey<FormState> formKey) => Form(
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
                label: 'Page Name',
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

  Form _buildProjectInputField(GlobalKey<FormState> formKey) => Form(
        key: formKey,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          title: AppTextField(
            label: 'Project Location',
            controller: widget.locationController,
            validator: (String? input) {
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
      );
}
