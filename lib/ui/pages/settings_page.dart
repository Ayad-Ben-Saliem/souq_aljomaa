import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/settings.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';

var existingSettings = Settings(
  serverUrl: sharedPreferences.getString('serverUrl'),
  showAllData: sharedPreferences.getBool('showAllData') ?? false,
);

final editingSetting = StateProvider((_) => existingSettings);

const defaultTextStyle = TextStyle(fontSize: 20);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الاعدادات'), centerTitle: true),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: SettingsForm(),
                ),
              ),
            ),
            const Divider(height: 0),
            _buttons(context),
          ],
        ),
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('إلغاء'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(editingSetting);
              return ElevatedButton(
                onPressed: settings == existingSettings
                    ? null
                    : () {
                        if (settings.serverUrl != existingSettings.serverUrl) {
                          sharedPreferences.setString('serverUrl', settings.serverUrl!);
                        }
                        if (settings.showAllData != existingSettings.showAllData) {
                          sharedPreferences.setBool('showAllData', settings.showAllData);
                        }
                        existingSettings = settings;

                        // ref.refresh(editingSetting);

                        // to refresh the page
                        final editingSettingStateController = ref.read(editingSetting.notifier);
                        editingSettingStateController.state = Settings();
                        editingSettingStateController.state = settings;

                        final width = MediaQuery.of(context).size.width;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.symmetric(horizontal: width / 2 - 128, vertical: 24),
                            content: const Center(child: Text('تم الحفظ بنجاح')),
                          ),
                        );
                      },
                child: const Text('حفظ'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('رابط الخادم الرئيسي (مثلا: http://192.168.1.1:5000)', style: defaultTextStyle),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (context, ref, child) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomTextFormField(
                    initialValue: ref.read(editingSetting).serverUrl,
                    decoration: const InputDecoration(
                      labelText: 'رابط الخادم',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (txt) {
                      final settings = ref.read(editingSetting.notifier);
                      settings.state = settings.state.copyWith(serverUrl: txt);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('إذا كنت تريد عرض جميع النماذج عند عدم البحث عن شيء معين', style: defaultTextStyle),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(
            builder: (context, ref, child) {
              return Switch(
                value: ref.watch(editingSetting.select((settings) => settings.showAllData)),
                onChanged: (active) {
                  final settings = ref.read(editingSetting.notifier);
                  settings.state = settings.state.copyWith(showAllData: active);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
