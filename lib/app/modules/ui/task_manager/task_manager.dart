import 'dart:io';

import 'package:getx_gui/app/groot/common/utils/pubspec/pubspec_utils.dart';
import 'package:getx_gui/app/groot/core/generator.dart';

Future<bool> callTask(List<String> arguments) async {
  try {
    //var time = Stopwatch();
    //time.start();
    PubspecUtils().loadFile(File('pubspec.yaml'));
    final command = GetCli(arguments).findCommand();

    if (arguments.contains('--debug')) {
      if (/*command.validate()*/ true) {
        await command.execute(); //.then((value) => checkForUpdate());
      }
    } else {
      try {
        if (/*command.validate()*/ true) {
          await command.execute(); //.then((value) => checkForUpdate());
        }
      } on Exception catch (e) {
        rethrow;
      }
    }
    // time.stop();
    // LogService.info('Time: ${time.elapsed.inMilliseconds} Milliseconds');
    return true;
  } catch (e) {
    return false;
  } finally {
    GetCli.clearArgs;
    //GetCli.clearInstance;
  }
}

/* void main(List<String> arguments) {
 Core core = Core();
  core
      .generate(arguments: List.from(arguments))
      .then((value) => checkForUpdate()); 
} */
