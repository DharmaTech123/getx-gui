import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:getx_gui/app/root/common/utils/pubspec/pubspec_utils.dart';
import 'package:getx_gui/app/root/models/generate_model.dart';
import 'package:pubspec/pubspec.dart';

import '../controllers/manage_dependency_controller.dart';

class ManageDependencyView extends GetView<ManageDependencyController> {
  ManageDependencyView({Key? key}) : super(key: key);

  @override
  ManageDependencyController controller = Get.put(ManageDependencyController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      title: Text(
                        'Manage Dependency',
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
                            items: ['Install', 'Remove'].map(
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
                    _buildManagePackageInputField(controller.formKey),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Dev Dependency'),
                      value: controller.isDev(),
                      onChanged: (value) => controller.isDev(value ?? false),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: AppButton(
                        onPressed: () => _onSubmitCreate(
                            controller.formKey, controller.defaultCommand),
                        title: 'Submit',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildListDependencies(
                      title: 'Dependencies',
                      dependencies: PubspecUtils.pubSpec.dependencies,
                    ),
                    const SizedBox(height: 20),
                    _buildListDependencies(
                      title: 'Dev Dependencies',
                      dependencies: PubspecUtils.pubSpec.devDependencies,
                    ),
                    const SizedBox(height: 20),
                    _buildListDependencies(
                      title: 'Dependency Overrides',
                      dependencies: PubspecUtils.pubSpec.dependencyOverrides,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildListDependencies(
      {required String title,
      required Map<String, DependencyReference> dependencies}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            dependencies.length,
            (index) => ListTile(
              minVerticalPadding: 0,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 0,
              ),
              title: Text(
                dependencies
                    .toString()
                    .split(',')[index]
                    .replaceAll('{', '')
                    .replaceAll('}', '')
                    .trim(),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSubmitCreate(
    GlobalKey<FormState> formKey,
    RxString defaultCommand,
  ) {
    if (formKey.currentState?.validate() ?? false) {
      Get.back<void>();
      if (defaultCommand.toLowerCase() == 'install') {
        Task.managePubspecPackage(
            packageName: controller.nameController.text,
            isRemoving: false,
            isDev: controller.isDev());
      } else if (defaultCommand.toLowerCase() == 'remove') {
        Task.managePubspecPackage(
            packageName: controller.nameController.text,
            isRemoving: true,
            isDev: controller.isDev());
      }
      controller.nameController.clear();
      controller.destinationController.clear();
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
              label: 'Package Name',
              controller: controller.nameController,
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
