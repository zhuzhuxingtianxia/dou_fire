import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_persist/redux_persist.dart' hide FileStorage;
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'models/state/app.dart';
import 'services/weiguan.dart';
import 'reducers/reducers.dart';
import 'utils/string.dart';

class Factory {
  static final Factory _singleton = Factory._();
  // 私有构造器
  Factory._();
  factory Factory() => _singleton;

  final Map<String, Logger> _loggers = {};
  late Persistor<AppState> _persistor;
  late Store<AppState> _store;
  late PersistCookieJar _cookieJar;
  late Service _service;

  Logger getLogger(String name) {
    if (_loggers[name] == null) {
      Logger.root.level = Config.loggerLevel;
      final logger = Logger(name);
      logger.onRecord
          .where((event) => event.loggerName == logger.name)
          .listen((event) {
        final label =
            event.loggerName.padRight(7).substring(0, 7).toLowerCase();
        final time = event.time.toIso8601String().substring(0, 23);
        final level = event.level.toString().padRight(7);
        // ignore: avoid_print
        print('$label $time $level ${event.message}');
      });
      _loggers[name] = logger;
    }
    return _loggers[name]!;
  }

  Persistor<AppState> getPersistor() {
    // ignore: unnecessary_null_comparison
    if (_persistor == null) {
      StorageEngine storageEngine =
          FlutterStorage(key: Config.packageInfo.appName);
      _persistor = Persistor<AppState>(
        storage: storageEngine,
        serializer: JsonSerializer<AppState>(AppState.fromJson),
      );

      /*
      _persistor = Persistor<AppState>(
        storage: storageEngine,
        decoder: (json) {
          var state = AppState.fromJson(json);
          if (compareVersion(state.version, Config.packageInfo.version, 2) !=
              0) {
            state = AppState();
          }
        },
      );
      */
    }
    return _persistor;
  }

  Store<AppState> getStore() {
    // ignore: unnecessary_null_comparison
    if (_store == null) {
      final List<Middleware<AppState>> wms = [];
      if (Config.isLogAction) {
        wms.add(LoggingMiddleware<AppState>(
            logger: getLogger('action'), level: Level.FINE));

        wms.addAll([thunkMiddleware, getPersistor().createMiddleware()]);

        _store = Store<AppState>(appReducer,
            initialState: AppState(), middleware: wms);
      }
    }
    return _store;
  }

  Future<PersistCookieJar> getCookieJar() async {
    // ignore: unnecessary_null_comparison
    if (_cookieJar == null) {
      var docDir = await getApplicationDocumentsDirectory();
      _cookieJar =
          PersistCookieJar(storage: FileStorage('${docDir.path}/cookies'));
    }

    return _cookieJar;
  }

  Future<Service> getService() async {
    // ignore: unnecessary_null_comparison
    if (_service == null) {
      var cookieJar = await getCookieJar();
      _service = Service(cookieJar);
    }

    return _service;
  }
}
