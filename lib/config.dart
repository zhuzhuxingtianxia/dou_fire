import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Config {
  static PackageInfo packageInfo =
      PackageInfo(appName: "", packageName: "", version: "", buildNumber: "");

  static var domain = 'doufire.app';
  static var apiBaseUrl = 'https://$domain/api';
  static var debug = false;
  static var loggerLevel = Level.INFO;
  static var isLogAction = false;
  static var isLogApi = false;
  static var isMockApi = true;

  static var launchTime = 0;
}
