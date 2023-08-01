import 'package:getx_gui/modules/common/utils/logger/log_utils.dart';
import 'package:getx_gui/modules/core/generator.dart';
import 'package:getx_gui/modules/exception_handler/exception_handler.dart';
import 'package:getx_gui/modules/functions/version/version_update.dart';
import 'package:getx_gui/modules/tasks_list.dart';

Future<bool> callTask(List<String> arguments) async {
  try {
    //var time = Stopwatch();
    //time.start();
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
    print('debug print return true');
    return true;
  } catch (e) {
    print('debug print return false');
    return false;
  } finally {
    print('debug print clear args ${GetCli.arguments.toSet()}');
    GetCli.clearArgs;
    print('debug print clear args ${GetCli.arguments.toSet()}');
    //GetCli.clearInstance;
  }
}

/* void main(List<String> arguments) {
 Core core = Core();
  core
      .generate(arguments: List.from(arguments))
      .then((value) => checkForUpdate()); 
} */
