import 'package:get/get.dart';

import '../controllers/create_project_controller.dart';

class CreateProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateProjectController>(
      () => CreateProjectController(),
    );
  }
}
