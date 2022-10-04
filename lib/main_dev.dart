import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'application.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Config.packageInfo = packageInfo;
  Config.debug = true;
  Config.loggerLevel = Level.ALL;
  Config.isLogAction = true;
  Config.isLogApi = true;
  Config.isMockApi = true;
  // ignore: avoid_print
  print(packageInfo);

  runApp(Application());
}
