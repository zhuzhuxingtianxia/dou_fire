import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  AppLaunch launch = await AppLaunch.getNativeData();
  print("${launch.type}:${launch.msg}");

  AppLaunch.onLaunch();
  AppLaunch.onTestBaseChannel("测试数据传递");

  runApp(Application());
}

const MethodChannel _channel = MethodChannel('native.launch');
const MethodChannel _onChannel = MethodChannel('flutter.launch');

class AppLaunch {
  final String type;
  final String msg;

  AppLaunch({
    required this.type,
    required this.msg,
  });

  static AppLaunch? _fromLaunch;

  static onLaunch() async {
    try {
      var res = await _onChannel.invokeMethod('onLaunch', {
        'type': 'launch',
        'result': 'succeed',
      });
      print(res);
    } catch (e) {
      print(e);
    }
  }

  static Future<AppLaunch> getNativeData() async {
    if (_fromLaunch != null) {
      return _fromLaunch!;
    }
    final map =
        await _channel.invokeMapMethod<String, dynamic>('getNativeData');

    _fromLaunch = AppLaunch(
      type: map!["type"] ?? '',
      msg: map["message"] ?? '',
    );
    return _fromLaunch!;
  }

  static Future onTestBaseChannel(String arg) async {
    final Object encoded = arg;
    const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
      'AppLaunch.onTestBaseChannel',
      StandardMessageCodec(),
    );
    final Map<Object?, Object?>? replyMap =
        await channel.send(encoded) as Map<Object?, Object?>?;

    print(replyMap);
  }
}
