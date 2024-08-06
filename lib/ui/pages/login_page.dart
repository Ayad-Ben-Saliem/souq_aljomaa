import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/data_provider/db.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:souq_aljomaa/ui/circle_indicator.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';
import 'package:souq_aljomaa/ui/link_text.dart';
import 'package:souq_aljomaa/ui/pages/server_url_page.dart';
import 'package:souq_aljomaa/ui/timer_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(body: Center(child: LoginForm())),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

final username = StateProvider((_) => '');
final password = StateProvider((_) => '');
final obscurePassword = StateProvider((_) => true);

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 512),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
                      child: Image.asset("assets/images/manassa-logo.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return CustomTextFormField(
                          decoration: const InputDecoration(labelText: 'اسم المستخدم', border: OutlineInputBorder()),
                          onChanged: (txt) => ref.read(username.notifier).state = txt,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return CustomTextFormField(
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => ref.read(obscurePassword.notifier).state = !ref.read(obscurePassword),
                              icon: Icon(ref.watch(obscurePassword) ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          obscureText: ref.watch(obscurePassword),
                          onChanged: (txt) => ref.read(password.notifier).state = txt,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton(
                            onPressed: onLoginButtonClicked(ref),
                            child: const CustomText('تسجيل الدخول'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 8),
                child: TimerWidget(
                  duration: const Duration(seconds: 5),
                  builder: (context) {
                    var color = Colors.red;
                    return FutureBuilder<bool>(
                      future: Restful.checkServer(),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          color = snapshot.data == true ? Colors.green : Colors.red;
                        }
                        return Container(decoration: CircleTabIndicator(color: color, radius: 4));
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServerUrlPage())),
                  icon: const Icon(Icons.settings),
                ),
              ),
              const Spacer(),
              const CustomText('جميع الحقوق محفوظة لصالح'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: LinkText('شركة منصة لتقنية المعلومات', url: 'https://www.manassa.ly'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  VoidCallback? onLoginButtonClicked(WidgetRef ref) {
    if (ref.watch(username).isEmpty || ref.watch(password).isEmpty) return null;

    return () {
      authController.login(ref.read(username), ref.read(password)).then((user) {
        ref.read(currentUser.notifier).state = user;

        if (user == null) {
          final width = MediaQuery.of(context).size.width;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(horizontal: width / 2 - 256, vertical: 24),
              content: const Column(
                children: [
                  CustomText('حدثت مشكلة في تسجيل الدخول'),
                  CustomText('تأكد من أن الخادم يعمل بشكل جيد'),
                  CustomText('أعد تشغيل الخادم إذا تطلب الأمر'),
                ],
              ),
            ),
          );
        }
      });
    };
  }
}
