import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:souq_aljomaa/storage/db.dart';
import 'package:souq_aljomaa/storage/restful.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:intl/intl_standalone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:window_manager/window_manager.dart';


late final SharedPreferences sharedPreferences;


void main() async {
  sharedPreferences = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

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

  // sharedPreferences.remove('serverUrl');

  // Database.initialize();
  final serverUrl = sharedPreferences.getString('serverUrl');
  print('serverUrl: $serverUrl');
  if(serverUrl != null && serverUrl.isNotEmpty) {
    Restful.initialize(serverUrl);
  }

  runApp(const ProviderScope(child: App()));
}
