import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/models/user.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';
import 'package:souq_aljomaa/ui/pages/home_page/home_page.dart';
import 'package:souq_aljomaa/ui/pages/users/users_page.dart';

final editingUser = StateProvider((_) => User(password: ''));
final obscurePassword = StateProvider((_) => true);
final confirmPassword = StateProvider((_) => '');

class AddEditUserForm extends ConsumerStatefulWidget {
  final User? user;

  const AddEditUserForm({super.key, this.user});

  @override
  ConsumerState<AddEditUserForm> createState() => _AddEditUserFormState();
}

class _AddEditUserFormState extends ConsumerState<AddEditUserForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.user != null) ref.read(editingUser.notifier).state = widget.user!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 512, maxHeight: 720),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.user == null ? 'إضافة مستخدم' : 'تعديل مستخدم (${widget.user?.fullName})',
              style: const TextStyle(fontSize: 20),
            ),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormField(
                      initialValue: widget.user?.name,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'الإسم'),
                      onChanged: (txt) {
                        final userStateController = ref.read(editingUser.notifier);
                        userStateController.state = userStateController.state.copyWith(name: txt);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextFormField(
                      initialValue: widget.user?.username,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'اسم المستخدم'),
                      onChanged: (txt) {
                        final userStateController = ref.read(editingUser.notifier);
                        userStateController.state = userStateController.state.copyWith(username: txt);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return CustomTextFormField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'كلمة المرور',
                            suffixIcon: IconButton(
                              onPressed: () => ref.read(obscurePassword.notifier).state = !ref.read(obscurePassword),
                              icon: Icon(ref.watch(obscurePassword) ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          obscureText: ref.watch(obscurePassword),
                          onChanged: (txt) {
                            final userStateController = ref.read(editingUser.notifier);
                            userStateController.state = userStateController.state.copyWith(password: txt);
                          },
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
                            labelText: 'تأكيد كلمة المرور',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => ref.read(obscurePassword.notifier).state = !ref.read(obscurePassword),
                              icon: Icon(ref.watch(obscurePassword) ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          obscureText: ref.watch(obscurePassword),
                          onChanged: (txt) => ref.read(confirmPassword.notifier).state = txt,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('مسؤول النظام؟'),
                  Consumer(
                    builder: (context, ref, child) {
                      return Switch(
                        value: ref.watch(editingUser.select((user) => user.isAdmin)),
                        onChanged: (isAdmin) {
                          final userStateController = ref.read(editingUser.notifier);
                          userStateController.state = userStateController.state.copyWith(isAdmin: isAdmin);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('يمكنه إضافة وتعديل وحذف النماذج؟'),
                  Consumer(
                    builder: (context, ref, child) {
                      return Switch(
                        value: ref.watch(editingUser.select((user) => user.modelsModifier)),
                        onChanged: (modelsModifier) {
                          final userStateController = ref.read(editingUser.notifier);
                          userStateController.state = userStateController.state.copyWith(modelsModifier: modelsModifier);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final user = ref.read(editingUser);
                          if (validate(user)) {
                            userController.addUser(user).then((user) {
                              if (user != null) {
                                ref.refresh(getUsers);
                                Navigator.pop(context, user);
                              }

                              final width = MediaQuery.of(context).size.width;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.symmetric(horizontal: width / 2 - 128, vertical: 24),
                                  content: Center(child: Text(user == null ? 'لم يتم حفظ المستخدم' : 'تم الحفظ بنجاح')),
                                ),
                              );
                            });
                          }
                        },
                        child: const Text('حفظ', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate(User user) {
    var result = true;
    final width = MediaQuery.of(context).size.width;
    if (user.username == null) {
      result = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: width / 2 - 128, vertical: 24),
          content: const Center(child: Text('اسم المستخدم (username) مطلوب')),
        ),
      );
    }
    if (user.password != ref.read(confirmPassword)) {
      result = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: width / 2 - 128, vertical: 24),
          content: const Center(child: Text('كلمتي المرور غير متطابقة')),
        ),
      );
    }
    return result;
  }
}
