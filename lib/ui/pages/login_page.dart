import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';

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
      child: ConstrainedBox(
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
                        style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                        child: const Text('تسجيل الدخول'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback? onLoginButtonClicked(WidgetRef ref) {
    if (ref.watch(username).isEmpty || ref.watch(password).isEmpty) return null;

    return () async {
      final user = await authController.login(ref.read(username), ref.read(password));
      ref.read(currentUser.notifier).state = user;
    };
  }
}
