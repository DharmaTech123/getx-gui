import 'dart:io';

import 'package:getx_gui/modules/input_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure.dart';
import '../../../../samples/impl/analysis_options.dart';
import '../../../interface/command.dart';
import '../../init/flutter/init.dart';
import '../../init/get_server/get_server_command.dart';

class CreateProjectCommand extends Command {
  @override
  String get commandName => 'project';
  @override
  Future<void> execute() async {
    print('debug print init execute');
    final menu = Menu([
      'Flutter Project',
      'Get Server',
    ], title: 'Select which type of project you want to create ?');
    final result = await menu.choose();
    String? nameProject = name;
    if (name == '.') {
      // final dialog = CLI_Dialog(questions: [
      //   [LocaleKeys.ask_name_to_project.tr, 'name']
      // ]);
      //nameProject = ask(LocaleKeys.ask_name_to_project.tr);
      nameProject =
          await showInputDialog(title: LocaleKeys.ask_name_to_project.tr);
    }

    var path = Structure.replaceAsExpected(
        path: Directory.current.path + p.separator + nameProject!.snakeCase);
    await Directory(path).create(recursive: true);

    Directory.current = path;

    if (result.index == 0) {
      // final dialog = CLI_Dialog(questions: [
      //   [
      //     '${LocaleKeys.ask_company_domain.tr} \x1B[33m '
      //         '${LocaleKeys.example.tr} com.yourcompany \x1B[0m',
      //     'org'
      //   ]
      // ]);

      /*var org = ask(
        '${LocaleKeys.ask_company_domain.tr} \x1B[33m '
        '${LocaleKeys.example.tr} com.yourcompany \x1B[0m',
      );*/

      var org = await showInputDialog(
          title: '${LocaleKeys.ask_company_domain.tr} \x1B[33m');

      final iosLangMenu =
          Menu(['Swift', 'Objective-C'], title: LocaleKeys.ask_ios_lang.tr);
      final iosResult = await iosLangMenu.choose();

      var iosLang = iosResult.index == 0 ? 'swift' : 'objc';

      final androidLangMenu =
          Menu(['Kotlin', 'Java'], title: LocaleKeys.ask_android_lang.tr);
      final androidResult = await androidLangMenu.choose();

      var androidLang = androidResult.index == 0 ? 'kotlin' : 'java';

      final nullSafeMenu = Menu(
          [LocaleKeys.options_yes.tr, LocaleKeys.options_no.tr],
          title: LocaleKeys.ask_use_null_safe.tr);
      final nullSafeMenuResult = await nullSafeMenu.choose();

      var useNullSafe = nullSafeMenuResult.index == 0;

      final linterMenu = Menu([
        'yes',
        'no',
      ], title: LocaleKeys.ask_use_linter.tr);
      final linterResult = await linterMenu.choose();

      await ShellUtils.flutterCreate(path, org, iosLang, androidLang);

      File('test/widget_test.dart').writeAsStringSync('');
      print('debug print init useNullSafe $useNullSafe');
      if (useNullSafe) {
        await ShellUtils.activatedNullSafe();
      }
      print('debug print init activatedNullSafe');
      switch (linterResult.index) {
        case 0:
          if (PubspecUtils.isServerProject) {
            print('debug print init ${PubspecUtils.isServerProject}');
            await PubspecUtils.addDependencies('lints',
                isDev: true, runPubGet: true);
            AnalysisOptionsSample(
                    include: 'include: package:lints/recommended.yaml')
                .create();
          } else {
            print('debug print init flutter_lints');
            await PubspecUtils.addDependencies('flutter_lints',
                isDev: true, runPubGet: true);
            AnalysisOptionsSample(
                    include: 'include: package:flutter_lints/flutter.yaml')
                .create();
          }
          break;

        default:
          print('debug print init default flutter_lints');
          AnalysisOptionsSample().create();
      }
      print('debug print init command');
      await InitCommand().execute();
    } else {
      print('debug print init GetServer');
      await InitGetServer().execute();
    }
    print('debug print init outer loop');
  }

  @override
  String? get hint => LocaleKeys.hint_create_project.tr;

  @override
  bool validate() {
    return true;
  }

  @override
  String get codeSample => 'get create project';

  @override
  int get maxParameters => 0;
}
