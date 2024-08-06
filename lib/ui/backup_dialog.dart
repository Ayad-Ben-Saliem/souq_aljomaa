import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/data_provider/restful.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';

final obscurePassword = StateProvider((_) => true);
final backupDirectory = StateProvider((_) => sharedPreferences.getString('backupDirectory') ?? '');
final backupPassword = StateProvider((_) => '');

class BackupDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  BackupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512, maxHeight: 512),
          child: Scaffold(
            appBar: AppBar(title: const CustomText('النسخ الإحتياطي'), centerTitle: true),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed: () => getDirectoryPath(
                            initialDirectory: ref.read(backupDirectory),
                            confirmButtonText: 'تأكيد',
                          ).then((txt) {
                            if (txt != null) ref.read(backupDirectory.notifier).state = txt;
                          }),
                          child: const CustomText('اختر مسار حفظ البيانات'),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(builder: (context, ref, child) => CustomText(ref.watch(backupDirectory))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
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
                          onChanged: (txt) => ref.read(backupPassword.notifier).state = txt,
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: ref.watch(backupDirectory).isEmpty
                                ? null
                                : () {
                                    Restful.backup(
                                      savePath: ref.read(backupDirectory),
                                      password: ref.read(backupPassword),
                                    ).then((result) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: CustomText(result ? 'تم الحفظ بنجاح' : 'لم يتم اخد نسخة احتياطية')),
                                      );
                                      if (result) {
                                        sharedPreferences.setString('backupDirectory', ref.read(backupDirectory));
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const CustomText('نسخ احتياطي'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showDialog(context: context, builder: (context) => BackupDialog());
  }
}
