import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:getx_gui/data/local/app_colors.dart';
import 'package:getx_gui/data/repository/app_repository.dart';

class ChooseLocation extends StatelessWidget {
  Function(String) onSubmit;

  ChooseLocation({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Choose',
        style: TextStyle(color: AppColors.k00CAA5),
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
