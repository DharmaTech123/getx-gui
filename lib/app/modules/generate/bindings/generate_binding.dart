import 'package:get/get.dart';

import '../controllers/generate_controller.dart';

class GenerateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateController>(
      () => GenerateController(),
    );
  }
}
