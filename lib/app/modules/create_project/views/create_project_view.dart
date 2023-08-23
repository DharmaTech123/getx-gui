import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';
import 'package:getx_gui/app/modules/ui/components/app_text_feild.dart';
import 'package:getx_gui/app/modules/ui/components/choose_location.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';

import '../controllers/create_project_controller.dart';

class CreateProjectView extends GetView<CreateProjectController> {
  CreateProjectView({Key? key}) : super(key: key);

  @override
  CreateProjectController controller = Get.put(CreateProjectController());

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
                _buildProjectInputField(),
                const SizedBox(height: 12),
                Center(
                  child: AppButton(
                    onPressed: () => _onSubmitCreate(),
                    title: 'Submit',
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  void _onSubmitCreate() {
    if (controller.formKey.currentState?.validate() ?? false) {
      Get.back<void>();
      Task.createProject();
      controller.locationController.clear();
    }
  }

  Form _buildProjectInputField() => Form(
        key: controller.formKey,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 28),
          title: AppTextField(
            label: 'Project Location',
            controller: controller.locationController,
            validator: (String? input) {
              if (input?.isEmpty ?? false) {
                return 'invalid input';
              }
              return null;
            },
          ),
          trailing: ChooseLocation(
            onSubmit: (path) {
              controller.locationController.text = path ?? '';
            },
          ),
        ),
      );
}
