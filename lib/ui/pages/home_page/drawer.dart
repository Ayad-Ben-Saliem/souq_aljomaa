import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:souq_aljomaa/ui/pages/settings_page.dart';
import 'package:souq_aljomaa/ui/pages/users/users_page.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer(
          builder: (context, ref, child) {
            final user = ref.watch(currentUser);
            return Column(
              children: [
                const SizedBox(height: 24),
                Text(user?.name ?? 'User', style: const TextStyle(fontSize: 20)),
                Text('(${user?.username})', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 12),
                const Divider(height: 0),
                if (ref.watch(currentUser)?.isAdmin == true)
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('الإعدادات', style: TextStyle(fontSize: 20)),
                    onTap: () => navigateToPage(context, const SettingsPage()),
                  ),
                if (ref.watch(currentUser)?.isAdmin == true)
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('المستخدمين', style: TextStyle(fontSize: 20)),
                    onTap: () => navigateToPage(context, const UsersPage()),
                  ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('تسجيل الخروج', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    authController.logout();
                    Navigator.pop(context);
                    ref.read(currentUser.notifier).state = null;
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
