import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';

// ignore_for_file: avoid_print

// ignore: avoid_classes_with_only_static_members
class LogService {
  static final AnsiPen _penError = AnsiPen()..red(bold: true);
  static final AnsiPen _penSuccess = AnsiPen()..green(bold: true);
  static final AnsiPen _penInfo = AnsiPen()..yellow(bold: true);
  static List<Widget> logData = [];

  static final AnsiPen code = AnsiPen()
    ..black(bold: false, bg: true)
    ..white();

  static final AnsiPen codeBold = AnsiPen()..gray(level: 1);

//  static var _errorWrapper = '_' * 40;
  static void error(String msg) {
    const sep = '\n';
    // to check: ⚠ ❌✖✕
    msg = '✖   ${_penError(msg.trim())}';
    msg = msg + sep;
    print(msg);
    logData.add(Text(msg));
    Task.hideLoader();
    Task.showStatusDialog(title: msg, isError: true);
  }

  static void success(dynamic msg) {
    const sep = '\n';
    msg = '✓   ${_penSuccess(msg.toString())}';
    msg = msg + sep;
    //Task.hideLoader();
    //Task.showStatusDialog(title: msg);
  }

  static void info(String msg, [bool trim = false, bool newLines = true]) {
    final sep = newLines ? '\n' : '';
    if (trim) msg = msg.trim();
    msg = _penInfo(msg);
    msg = sep + msg.toString() + sep;
    print(msg);
    logData.add(Text(msg));
  }
}
