
import 'package:getx_gui/app/groot/core/generator.dart';

import '../../../common/utils/logger/log_utils.dart';
import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../common/utils/shell/shel.utils.dart';
import '../../../core/internationalization.dart';
import '../../../core/locales.g.dart';
import '../../../exception_handler/exceptions/cli_exception.dart';
import '../../interface/command.dart';

class RemoveCommand extends Command {
  @override
  String get commandName => 'remove';
  @override
  Future<void> execute() async {
    var isDev = containsArg('--dev') || containsArg('-dev');
    for (var package in GetCli.arguments) {
      PubspecUtils.removeDependencies(package, isDev: isDev);
    }

    //if (GetCli.arguments.first == 'remove') {
    await ShellUtils.pubGet();
    //}
  }

  @override
  String? get hint => Translation(LocaleKeys.hint_remove).tr;

  @override
  bool validate() {
    super.validate();
    if (GetCli.arguments.isEmpty) {
      CliException(LocaleKeys.error_no_package_to_remove.tr,
          codeSample: codeSample);
    }
    return true;
  }

  @override
  String? get codeSample => LogService.code('get remove http');

  @override
  int get maxParameters => 999;
  @override
  List<String> get alias => ['-rm'];
}
