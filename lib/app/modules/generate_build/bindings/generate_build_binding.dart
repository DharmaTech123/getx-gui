import 'package:get/get.dart';

import '../controllers/generate_build_controller.dart';

class GenerateBuildBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateBuildController>(
      () => GenerateBuildController(),
    );
  }
}
