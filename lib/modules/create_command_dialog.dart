import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/components/app_button.dart';
import 'package:getx_gui/components/app_text_feild.dart';
import 'package:getx_gui/data/app_colors.dart';
import 'package:getx_gui/modules/models/create_model.dart';
import 'package:getx_gui/modules/tasks_list.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                title: Text(
                  'Create',
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
                      items: CreateModel().createCommandList.map(
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
              _buildInputTextFieldWidgets(
                  widget.defaultCommand, widget.formKey),
              const SizedBox(height: 25),
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
  }

  void _onSubmitCreate(GlobalKey<FormState> formKey, String? defaultCommand) {
    if (formKey.currentState?.validate() ?? false) {
      Get.back();
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
  }

  Form _buildPageInputField(GlobalKey<FormState> formKey) {
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
  }

  Form _buildProjectInputField(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 28),
        title: AppTextField(
          label: 'Project Location',
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
    );
  }

  _chooseFile() async {
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

void showCreateDialog({required String title}) {
  /* return _buildCreateDialog(title, defaultCommand, formKey);
  showDialog(
    context: Get.context!,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return _buildCreateDialog(title, defaultCommand, formKey);
    },
  );*/
}

SimpleDialog _buildCreateDialog(
    String title, String? defaultCommand, GlobalKey<FormState> formKey) {
  return SimpleDialog(
    title: Text(title),
    children: const [
      /*StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          //return _buildCreate(setState, defaultCommand, formKey);
        },
      )*/
    ],
  );
}
