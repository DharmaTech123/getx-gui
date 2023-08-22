import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

RxBool isTaskRunning = false.obs;
RxString currentWorkingDirectory = '${Directory.current}'.obs;
