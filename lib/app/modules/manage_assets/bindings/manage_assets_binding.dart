import 'package:get/get.dart';

import '../controllers/manage_assets_controller.dart';

class ManageAssetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageAssetsController>(
      () => ManageAssetsController(),
    );
  }
}
