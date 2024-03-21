import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:souq_aljomaa/storage/db.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:intl/intl_standalone.dart';

late final SharedPreferences sharedPreferences;


void main() async {
  sharedPreferences = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

  await findSystemLocale();

  if (Platform.isLinux) PathProviderLinux.registerWith();
  if (Platform.isWindows) PathProviderWindows.registerWith();

  Database.initialize();
  runApp(const ProviderScope(child: App()));
}
