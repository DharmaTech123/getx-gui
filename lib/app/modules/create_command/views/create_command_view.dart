import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/groot/models/create_model.dart';

import '../controllers/create_command_controller.dart';

class CreateCommandView extends GetView<CreateCommandController> {
  CreateCommandView({Key? key}) : super(key: key);

  @override
  CreateCommandController controller = Get.put(CreateCommandController());

  @override
  Widget build(BuildContext context) => Obx(
        () => Scaffold(
          body: ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  12.verticalSpace,
                  ListTile(
                    tileColor: Theme.of(Get.context as BuildContext)
                        .primaryColor
                        .withOpacity(0.1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
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
                            controller.defaultCommand(value);
                          },
                          hint: const Text('Select Command'),
                          value: controller.defaultCommand(),
                          isDense: false,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                  ).paddingAll(25),
                  12.verticalSpace,
                  _buildInputTextFieldWidgets(
                    controller.defaultCommand(),
                    controller.formKey,
                  ),
                  12.verticalSpace,
                  Center(
                    child: AppButton(
                      onPressed: () => _onSubmitCreate(
                        controller.formKey,
                        controller.defaultCommand(),
                      ),
                      title: 'Submit',
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        Task.createModule(pageName: controller.nameController.text);
      } else if (defaultCommand.toLowerCase() ==
          CreateCommandName.controller.name) {
        Task.createController(
          controllerName: controller.nameController.text,
          moduleName: controller.destinationController.text,
        );
      } else if (defaultCommand.toLowerCase() == CreateCommandName.view.name) {
        Task.createView(
          viewName: controller.nameController.text,
          moduleName: controller.destinationController.text,
        );
      } else if (defaultCommand.toLowerCase() ==
          CreateCommandName.provider.name) {
        Task.createProvider(
          providerName: controller.nameController.text,
          moduleName: controller.destinationController.text,
        );
      }
      controller.nameController.clear();
      controller.destinationController.clear();
    }
  }

  Widget _buildInputTextFieldWidgets(
      String? defaultCommand, GlobalKey<FormState> formKey) {
    if (defaultCommand == null) {
      return const SizedBox.shrink();
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
                label: '$defaultCommand Name',
                controller: controller.nameController,
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
                controller: controller.destinationController,
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
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          title: AppTextField(
            label: 'Page Name',
            controller: controller.nameController,
            validator: (input) {
              if (input?.isEmpty ?? false) {
                return 'invalid input';
              }
              return null;
            },
          ),
        ),
      );
}
