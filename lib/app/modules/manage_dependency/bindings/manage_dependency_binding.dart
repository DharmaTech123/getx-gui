import 'package:get/get.dart';

import '../controllers/manage_dependency_controller.dart';

class ManageDependencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageDependencyController>(
      () => ManageDependencyController(),
    );
  }
}
