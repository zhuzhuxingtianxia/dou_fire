import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'models/models.dart';
import 'theme.dart';
import 'config.dart';
import 'factory.dart';
import 'pages/pages.dart';
import 'models/state/app.dart';

class Application extends StatelessWidget {
  Application({super.key}) {
    logger.info(
        'Config(debug: ${Config.debug}, loggerLevel: ${Config.loggerLevel})');

    persistor.load();
  }

  final logger = Factory().getLogger('app');
  final persistor = Factory().getPersistor();
  final store = Factory().getStore();

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: Config.packageInfo.appName,
        theme: DFTheme.theme,
        initialRoute: '/',
        routes: {
          '/': (context) => const BootstrapPage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/tab': (context) => TabPage()
        },
      ),
    );
  }
}
