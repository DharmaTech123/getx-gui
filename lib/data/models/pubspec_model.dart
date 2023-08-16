import 'dart:io';
import 'dart:math';
import 'package:getx_gui/modules/common/utils/pubspec/pubspec_utils.dart';
import 'package:path/path.dart' as p;

class PubspecModel {
  static List assets =
      (PubspecUtils.pubSpec.unParsedYaml!['flutter']['assets']) as List;
  static List<PubspecDirectory> pubspecDirectoryList = [];
  static List<String> completedDirectories = [];

  static List<PubspecDirectory> readAssets() {
    pubspecDirectoryList.clear();
    completedDirectories.clear();
    for (var dir in assets) {
      traverseDirectory(dir);
    }

    return pubspecDirectoryList;
  }

  static void traverseDirectory(String directory) {
    if (File(directory).existsSync()) {
      if (!completedDirectories.contains(p.dirname(directory))) {
        _readDirectoryItem(p.dirname(directory));
      }
    } else if (Directory(directory).existsSync()) {
      if (!completedDirectories.contains(directory)) {
        _readDirectoryItem(directory);
      }
    }
  }

  static void _readDirectoryItem(String directory) {
    completedDirectories.add(directory);
    List<PubspecItem> pubspecItemList = [];
    Directory(directory)
        .listSync(recursive: true, followLinks: false)
        .forEach((FileSystemEntity file) {
      if (file is File) {
        pubspecItemList.add(PubspecItem(
          directory: p.dirname(file.path),
          fileName: p.basename(file.path),
          fileSize: File(file.path).lengthSync(),
        ));
      }
    });
    pubspecDirectoryList.add(
      PubspecDirectory(
        directory: p.dirname(directory),
        pubspecItemList: pubspecItemList,
      ),
    );
  }
}

class PubspecDirectory {
  String directory;
  List<PubspecItem> pubspecItemList;

  PubspecDirectory({
    required this.directory,
    required this.pubspecItemList,
  });
}

class PubspecItem {
  String directory;
  String fileName;
  int fileSize;

  PubspecItem({
    required this.directory,
    required this.fileName,
    required this.fileSize,
  });
}
