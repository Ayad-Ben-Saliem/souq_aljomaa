import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/controllers/restful/restful_auth_controller.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/user.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/pages/home_page/home_page.dart';
import 'package:souq_aljomaa/ui/pages/loading_page.dart';
import 'package:souq_aljomaa/ui/pages/login_page.dart';
import 'package:souq_aljomaa/ui/pages/server_url_page.dart';
import 'package:window_manager/window_manager.dart';

final authController = RestfulAuthController();
final autoLoginUser = FutureProvider<User?>((ref) async {
  final accessToken = sharedPreferences.getString('access_token');

  return accessToken != null ? authController.autoLogin(accessToken) : null;
});

final currentUser = StateProvider<User?>((ref) {
  final gettingUser = ref.watch(autoLoginUser);
  return gettingUser.hasValue ? gettingUser.value : null;
});

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
              title: const CustomText('تأكيد الإغلاق'),
              content: const CustomText('هل أنت متأكد من انك تريد إغلاق البرنامج؟'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Dismiss the dialog and return false,
                  child: const CustomText('إلغاء'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Dismiss the dialog and return true
                  child: const CustomText('إغلاق'),
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
        child: Builder(
          builder: (context) {
            final serverUrl = sharedPreferences.getString('serverUrl');
            if (serverUrl == null || serverUrl.isEmpty) return const ServerUrlPage();

            return Consumer(
              builder: (context, ref, child) {
                final gettingUser = ref.watch(autoLoginUser);
                return gettingUser.when(
                  loading: () => const LoadingPage(),
                  error: (err, stack) => CustomText('خطأ: $err'),
                  data: (value) {
                    if (ref.watch(currentUser) == null) return const LoginPage();

                    return const HomePage();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
