import 'package:get/get.dart';

import '../controllers/create_command_controller.dart';

class CreateCommandBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateCommandController>(
      () => CreateCommandController(),
    );
  }
}
