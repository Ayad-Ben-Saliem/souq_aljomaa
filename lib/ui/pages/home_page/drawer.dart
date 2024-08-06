import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
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
                CustomText(user?.name ?? 'مستخدم'),
                CustomText('(${user?.username})'),
                const SizedBox(height: 12),
                const Divider(height: 0),
                if (ref.watch(currentUser)?.isAdmin == true)
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const CustomText('الإعدادات'),
                    onTap: () => navigateToPage(context, const SettingsPage()),
                  ),
                if (ref.watch(currentUser)?.isAdmin == true)
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const CustomText('المستخدمين'),
                    onTap: () => navigateToPage(context, const UsersPage()),
                  ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const CustomText('تسجيل الخروج'),
                  onTap: () {
                    authController.logout();
                    Navigator.pop(context);
                    ref.read(currentUser.notifier).state = null;
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const CustomText('حول الشركة'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const CustomAboutDialog();
                        final size = MediaQuery.of(context).size;
                        return AboutDialog(
                          applicationIcon: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 64, maxHeight: 64),
                            child: Image.asset("assets/images/manassa-logo.png"),
                          ),
                          applicationVersion: '2.0.1',
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: size.width / 2, maxHeight: size.height / 2),
                              child: const CustomText(
                                '''
                                ''',
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        );
                      },
                    );
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

class CustomAboutDialog extends StatelessWidget {
  const CustomAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const CustomText('حول ...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText('منظومة البلديات', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const CustomText('الإصدار 2.0.1'),
            const SizedBox(height: 8),
            const CustomText('© 2024 Manassa Ltd.'),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width / 2, maxHeight: size.height / 2),
              child: const CustomText(
                '''منصة - Manassa هي شركة تقنية معلومات تأسست عام 2018، تقدم حلول تقنية مبتكرة ومخصصة تلبي احتياجات مختلف الجهات بأعلى معايير الجودة. فريقنا يضم نخبة من الخبراء والمطورين المتخصصين في مجالات متعددة من تقنية المعلومات، مما يمكننا من تقديم حلول متكاملة ومتطورة.''',
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width / 2, maxHeight: size.height / 2),
              child: const CustomText(
                'هذا النظام هو ملكية خاصة لشركة "منصة - Manassa" ويُحظر تداوله أو استخدامه لأي غرض تجاري بدون إذن خطي مسبق من الشركة. جميع الحقوق محفوظة.'
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText('حسنا'),
          ),
        ],
      ),
    );
  }
}
