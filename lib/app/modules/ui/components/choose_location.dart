import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getx_gui/app/data/local/app_colors.dart';
import 'package:getx_gui/app/data/repository/app_repository.dart';

class ChooseLocation extends StatelessWidget {
  Function(String) onSubmit;
  String? label;
  Widget? child;

  ChooseLocation({super.key, required this.onSubmit, this.label, this.child});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: child ??
          Text(
            label ?? 'Choose',
          ),
      onPressed: () => _chooseFile(),
    );
  }

  void _chooseFile() async {
    try {
      final String? selectedDirectory = await getDirectoryPath();
      if (selectedDirectory != null) {
        onSubmit.call(selectedDirectory);
        currentWorkingDirectory(selectedDirectory);
        Directory.current = selectedDirectory;
        return;
      }
    } catch (e) {}
  }
}
