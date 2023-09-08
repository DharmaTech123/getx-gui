import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/groot/models/generate_model.dart';

import '../controllers/generate_controller.dart';

class GenerateView extends GetView<GenerateController> {
  GenerateView({Key? key}) : super(key: key);

  @override
  GenerateController controller = Get.put(GenerateController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            ListTile(
              tileColor: Theme.of(Get.context as BuildContext)
                  .primaryColor
                  .withOpacity(0.1),
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
            const SizedBox(height: 12),
            _buildInputTextFieldWidgets(),
            const SizedBox(height: 12),
            Center(
              child: AppButton(
                onPressed: () => _onSubmitCreate(),
                title: 'Submit',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmitCreate() {
    if (controller.formKey.currentState?.validate() ?? false) {
      Get.back<void>();
      if (controller.defaultCommand.toLowerCase() ==
          GenerateCommandName.locales.name) {
        Task.generateLocales(
            destinationFolder: controller.destinationController.text);
      } else if (controller.defaultCommand.toLowerCase() ==
          GenerateCommandName.model.name) {
        Task.generateModel(
          moduleName: controller.nameController.text,
          modelSource:
              controller.modelSource.contains('From Local') ? 'with' : 'from',
          destinationFolder: controller.destinationController.text,
        );
      }
      controller.nameController.clear();
      controller.destinationController.clear();
    }
  }

  Widget _buildInputTextFieldWidgets() {
    if (controller.defaultCommand.toLowerCase() ==
        GenerateCommandName.locales.name) {
      return _buildGenerateLocaleInputField();
    } else if (controller.defaultCommand.toLowerCase() ==
        GenerateCommandName.model.name) {
      return _buildGenerateModelInputField();
    }
    return const SizedBox.shrink();
  }

  Form _buildGenerateLocaleInputField() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            title: AppTextField(
              label: 'directory with your translation files in json format',
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
  }

  Form _buildGenerateModelInputField() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            title: AppTextField(
              label: 'Module Name',
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
            tileColor: Theme.of(Get.context as BuildContext)
                .primaryColor
                .withOpacity(0.1),
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
                    controller.modelSource(value);
                  },
                  hint: const Text('From'),
                  value: controller.modelSource.value,
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
  }
}
