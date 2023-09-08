import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_gui/app/modules/ui/components/app_button.dart';

import '../controllers/generate_build_controller.dart';

class GenerateBuildView extends GetView<GenerateBuildController> {
  GenerateBuildView({Key? key}) : super(key: key);
  @override
  GenerateBuildController controller = Get.put(GenerateBuildController());

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
                            items: ['Android', 'iOS', 'Windows'].map(
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
                    Center(
                      child: AppButton(
                        onPressed: () => controller.generateBuild(),
                        title: 'Submit',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
