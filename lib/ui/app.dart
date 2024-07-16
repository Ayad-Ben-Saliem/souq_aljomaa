import 'package:flutter/material.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/ui/home_page.dart';
import 'package:souq_aljomaa/ui/pages/settings_page.dart';
import 'package:window_manager/window_manager.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool shouldClose = await _showExitConfirmation(context);
    if (shouldClose) {
      windowManager.destroy();
    } else {
      windowManager.setPreventClose(true);
    }
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Dismiss the dialog and return false,
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Dismiss the dialog and return true
                  child: const Text('Exit'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منظومة البلديات',
      theme: ThemeData(fontFamily: 'Harf-Fannan', useMaterial3: false),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Builder(builder: (context) {
          final serverUrl = sharedPreferences.getString('serverUrl');
          if (serverUrl == null || serverUrl.isEmpty) return const SettingsPage();

          return const HomePage();
        }),
      ),
    );
  }
}
