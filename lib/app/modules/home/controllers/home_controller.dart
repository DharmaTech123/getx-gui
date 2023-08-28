import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  RxString projectName = 'GETX UI'.obs;

  @override
  void onInit() {
    super.onInit();

    projectName(p.basename(Directory.current.path));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
