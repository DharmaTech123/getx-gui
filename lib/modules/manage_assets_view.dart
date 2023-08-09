import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_gui/modules/common/utils/pubspec/pubspec_utils.dart';
import 'package:getx_gui/modules/core/structure.dart';
import 'package:getx_gui/modules/extensions/string.dart';
import 'package:path/path.dart' as p;

class ManageAssets extends StatefulWidget {
  ManageAssets({super.key});

  @override
  State<ManageAssets> createState() => _ManageAssetsState();
}

class _ManageAssetsState extends State<ManageAssets> {
  Map<dynamic, dynamic>? assets = PubspecUtils.pubSpec.unParsedYaml;

  RxList<String> fileSizes = <String>[].obs;

  @override
  void initState() {
    super.initState();
    readAssets();
  }

  void readAssets() {
    if (assets != null) {
      if (assets!['flutter'] != null) {
        if (assets!['flutter']['assets'] != null) {
          for (var element in (assets!['flutter']['assets'] as List)) {
            traverseDirectory(element);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                title: Text(
                  'Assets',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    fileSizes.length,
                    (index) => Text(fileSizes[index]).paddingSymmetric(
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void traverseDirectory(String dirPath) {
    if (File(dirPath).existsSync()) {
      fileSizes.add(
          '$dirPath : ${getFileSizeString(bytes: File(dirPath).lengthSync(), decimals: 2)}');
    } else if (Directory(dirPath).existsSync()) {
      Directory(dirPath)
          .listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity file) {
        if (file is File) {
          fileSizes.add(
              '${file.path} : ${getFileSizeString(bytes: File(file.path).lengthSync(), decimals: 2)}');
        }
      });
    }
    fileSizes.refresh();
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  String getFileSize(String dirPath) {
    var fileSizeInBytes = 0;
    try {
      var file = File(dirPath);
      if (file.existsSync()) {
        if (file.statSync().type == FileSystemEntityType.file) {
          fileSizeInBytes = File(dirPath).lengthSync();
        } else if (file.statSync().type == FileSystemEntityType.directory) {
          List<String> fileSizes = [];
          Directory(dirPath)
              .listSync(recursive: true, followLinks: false)
              .forEach((FileSystemEntity file) {
            if (file is File) {
              fileSizes.add(((file.lengthSync()) / 1024).toStringAsFixed(2));
            }
          });
          return fileSizes.toString();
        }
      }
    } catch (e) {}
    return (fileSizeInBytes / 1024).toStringAsFixed(2);
    return '';
  }
}
