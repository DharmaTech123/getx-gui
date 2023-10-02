import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';

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
                controller.pubSpec != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildListDependencies(
                            title: 'Dependencies',
                            dependencies: controller
                                .pubSpec!.dependencies.entries
                                .map((e) => '${e.key}: ${e.value}')
                                .toList(),
                            unUsed: controller.unusedDependencies.value,
                          ),
                          _buildListDependencies(
                            title: 'Dev Dependencies',
                            dependencies: controller
                                .pubSpec!.devDependencies.entries
                                .map((e) => '${e.key}: ${e.value}')
                                .toList(),
                            isDev: true,
                            unUsed: controller.unusedDevDependencies.value,
                          ),
                          _buildListDependencies(
                            title: 'Dependency Overrides',
                            dependencies: controller
                                .pubSpec!.dependencyOverrides.entries
                                .map((e) => '${e.key}: ${e.value}')
                                .toList(),
                            unUsed: [],
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 30)
                    : const SizedBox.shrink(),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListDependencies({
    required String title,
    required List<String> dependencies,
    required List<String> unUsed,
    bool isDev = false,
  }) {
    return dependencies.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: REdgeInsets.symmetric(vertical: 20),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  unUsed.isEmpty ? '' : '${unUsed.length} unused',
                  style: const TextStyle(color: Colors.red),
                ),
                children: List.generate(
                  dependencies.length,
                  (index) => ListTile(
                    onTap: () {
                      if (unUsed.contains(
                          dependencies[index].split(':').first.trim())) {
                        controller.showRemoveAssetsDialog(
                          packageName:
                              dependencies[index].trim().replaceAll('"', ''),
                          isDev: isDev,
                        );
                      }
                    },
                    minVerticalPadding: 0,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      dependencies[index].trim().replaceAll('"', ''),
                      style: TextStyle(
                        color: unUsed.contains(
                                dependencies[index].split(':').first.trim())
                            ? Colors.red
                            : Colors.black,
                      ),
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
