import 'dart:io';
import 'dart:math';
import 'package:getx_gui/app/data/local/unused_assets_detector.dart';
import 'package:getx_gui/app/groot/common/utils/pubspec/pubspec_utils.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec/pubspec.dart';

class PubspecModel {
  /*static List assets =
      (PubSpec.fromYamlString(File('pubspec.yaml').readAsStringSync())
          .unParsedYaml!['flutter']['assets']) as List;*/
  static List<PubspecDirectory> pubspecDirectoryList = [];
  static List<String> completedDirectories = [];

  static int totalUnused = 0;

  static Future<List<PubspecDirectory>> readAssets(List assets) async {
    pubspecDirectoryList.clear();
    completedDirectories.clear();
    totalUnused = 0;
    for (var dir in assets) {
      traverseDirectory(dir);
    }
    await AssetsDetector.findUnusedAssets(
      pubspecDirectoryList,
      '${Directory.current.path}\\lib',
    );
    for (var dir in pubspecDirectoryList) {
      for (var file in dir.pubspecItemList) {
        if (!file.isUsed) {
          totalUnused++;
        }
      }
    }
    return pubspecDirectoryList;
  }

  static void traverseDirectory(String directory) {
    if (File(directory).existsSync()) {
      if (!completedDirectories.contains(p.dirname(directory))) {
        _readDirectoryItem(
            p.dirname(directory) == '.' ? directory : p.dirname(directory));
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
    if (File(directory).existsSync()) {
      pubspecItemList.add(PubspecItem(
        directory: directory,
        fileName: directory,
        fileSize: File(directory).lengthSync(),
      ));
    } else if (Directory(directory).existsSync()) {
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
    }
    pubspecDirectoryList.add(
      PubspecDirectory(
        directory: p.dirname(directory),
        pubspecItemList: pubspecItemList,
      ),
    );
    /* List<PubspecItem> pubspecItemList = [];
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
    );*/
  }
}

class PubspecDirectory {
  String directory;
  List<PubspecItem> pubspecItemList = <PubspecItem>[];

  PubspecDirectory({
    required this.directory,
    required this.pubspecItemList,
  });

  int getDirectorySize() {
    return pubspecItemList.fold(0,
        (previousValue, currentValue) => previousValue + currentValue.fileSize);
  }
}

class PubspecItem {
  String directory;
  String fileName;
  int fileSize;
  bool isUsed = false;

  PubspecItem({
    required this.directory,
    required this.fileName,
    required this.fileSize,
  });
}
