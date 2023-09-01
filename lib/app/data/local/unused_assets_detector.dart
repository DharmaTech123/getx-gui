import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getx_gui/app/data/model/pubspec_model.dart';
import 'package:path/path.dart' as p;

class AssetsDetector {
  static void findUnusedAssets(
      RxList<PubspecDirectory> pubspecDirectoryList, String libPath) {
    for (var dir in pubspecDirectoryList) {
      for (var files in dir.pubspecItemList) {
        print(files.fileName);
        bool status = traverseDirectory(files.fileName, libPath);
        files.isUsed = status;
      }
    }
  }

  static bool traverseDirectory(String fileName, String directory) {
    if (File(directory).existsSync()) {
      return _readDirectoryItem(p.dirname(directory), fileName);
    } else if (Directory(directory).existsSync()) {
      return _readDirectoryItem(directory, fileName);
    }
    return false;
  }

  static bool _readDirectoryItem(String directory, String fileName) {
    bool status = false;
    Directory(directory)
        .listSync(recursive: true, followLinks: false)
        .forEach((FileSystemEntity file) async {
      if (file is File) {
        if (await file
            .readAsString()
            .then((value) => value.contains(fileName))) {
          status = true;
          print('debug print file readAsString used ${file.path} $fileName');
        }
        status = false;
        print('debug print file readAsString un used ${file.path} $fileName');
      }
    });
    return status;
  }
}
