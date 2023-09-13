import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/ui/task_manager/tasks_list.dart';
import 'app/routes/app_pages.dart';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    ScreenUtilInit(
      designSize: const Size(1280, 720),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      child: GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    ),
  );
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runZonedGuarded(() async {
    runApp(
      ScreenUtilInit(
        designSize: const Size(1280, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        child: GetMaterialApp(
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: ThemeData(
            useMaterial3: true,
          ),
        ),
      ),
    ); // starting point of app
  }, (error, stackTrace) {
    print('debug print error');
    print("Error FROM OUT_SIDE FRAMEWORK ");
    print("--------------------------------");
    print("Error :  $error");
    print("StackTrace :  $stackTrace");
  });
}
