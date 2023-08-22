import 'package:get/get.dart';

import '../controllers/start_up_controller.dart';

class StartUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StartUpController>(
      () => StartUpController(),
    );
  }
}
