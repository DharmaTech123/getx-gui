import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getx_gui/app/data/model/pubspec_model.dart';
import 'package:getx_gui/app/modules/ui/task_manager/tasks_list.dart';
import 'package:path/path.dart' as p;

class AssetsDetector {
  static Future<void> findUnusedAssets(
      List<PubspecDirectory> pubspecDirectoryList, String libPath) async {
    for (var dir in pubspecDirectoryList) {
      for (var file in dir.pubspecItemList) {
        file.isUsed = false;
      }
    }
    await traverseDirectory(pubspecDirectoryList, libPath);
  }

  static Future<void> traverseDirectory(
      List<PubspecDirectory> pubspecDirectoryList, String directory) async {
    if (File(directory).existsSync()) {
      await _readDirectoryItem(p.dirname(directory), pubspecDirectoryList);
    } else if (Directory(directory).existsSync()) {
      await _readDirectoryItem(directory, pubspecDirectoryList);
    }
  }

  static Future<void> _readDirectoryItem(
    String directory,
    List<PubspecDirectory> pubspecDirectoryList,
  ) async {
    List<FileSystemEntity> files =
        Directory(directory).listSync(recursive: true, followLinks: false);

    for (var file in files) {
      await _markFileUsedOrUnused(file, pubspecDirectoryList);
    }
  }

  static Future<void> _markFileUsedOrUnused(FileSystemEntity file,
      List<PubspecDirectory> pubspecDirectoryList) async {
    if (file is File) {
      String fileContent = await file.readAsString();
      for (var dir in pubspecDirectoryList) {
        for (var files in dir.pubspecItemList) {
          if (dir.pubspecItemList.indexWhere((element) => !element.isUsed) !=
              -1) {
            if (!files.isUsed) {
              files.isUsed = fileContent.contains(files.fileName);
            }
          }
        }
      }
    }
  }
}
