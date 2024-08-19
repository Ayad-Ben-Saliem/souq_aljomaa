import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:intl/intl_standalone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:souq_aljomaa/utils.dart';
import 'package:window_manager/window_manager.dart';

late final SharedPreferences sharedPreferences;

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.getInstance().then((preferences) => sharedPreferences = preferences);

    initializeDateFormatting();
    await findSystemLocale();

    if (Platform.isLinux) PathProviderLinux.registerWith();
    if (Platform.isWindows) PathProviderWindows.registerWith();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      // size: Size(800, 600),
      center: true,
      skipTaskbar: false,
      title: 'منظومة البلديات',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    final serverUrl = sharedPreferences.getString('serverUrl');
    if (serverUrl != null && serverUrl.isNotEmpty) Restful.initialize();

    runApp(const ProviderScope(child: App()));
  }, (error, stackTrace) {
    _handleError(error, stackTrace);
  });
}

void _handleError(Object error, StackTrace stackTrace) {
  // Log the error and stack trace
  debug('Caught error: $error');
  debug('Stack trace: $stackTrace');

  // Catch error to deal with
  Utils.catchError(error, stackTrace);
}
