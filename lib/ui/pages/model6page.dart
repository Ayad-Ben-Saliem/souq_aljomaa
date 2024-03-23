import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/model6.dart';
import 'package:souq_aljomaa/storage/file_manager.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';
import 'package:souq_aljomaa/ui/home_page.dart';

final _modelProvider = StateProvider((ref) => _initialValue);

final _formKey = GlobalKey<FormState>();

var _initialValue = const Model6(
  ownerName: '',
  ownerPhone: '',
  tenantName: '',
  tenantPhone: '',
  streetCode: '',
  shopNo: '',
  businessType: '',
  businessCategory: '',
);

class Model6Page extends ConsumerStatefulWidget {
  final Model6? model;

  const Model6Page({super.key, this.model});

  @override
  ConsumerState<Model6Page> createState() => _Model6PageState();
}

class _Model6PageState extends ConsumerState<Model6Page> {
  @override
  void initState() {
    super.initState();

    final model = widget.model;
    if (model != null) {
      _initialValue = model.copyWith();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(_modelProvider.notifier).state = _initialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText(_initialValue.documentTitle), centerTitle: true),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 500, maxWidth: 1000),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Image.asset('assets/images/حكومة الوحدة الوطنية.jpg')),
                                SizedBox(height: 128, child: Image.asset('assets/images/Government_logo.png')),
                                Expanded(child: Image.asset('assets/images/وزارة الحكم المحلي.jpg')),
                              ],
                            ),
                            const CustomText('بلدية سوق الجمعة'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('اسم المالك: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.ownerName,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(ownerName: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.ownerName)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('رقم هاتف المالك: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.ownerPhone,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(ownerPhone: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.ownerPhone)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('اسم المستأجر: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.tenantName,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(tenantName: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.tenantName)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('رقم هاتف المستأجر: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.tenantPhone,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(tenantPhone: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.tenantPhone)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('رمز الشارع: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.streetCode,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(streetCode: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.streetCode)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('رقم المحل: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.shopNo,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(shopNo: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.shopNo)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('نوع النشاط: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.businessType,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(businessType: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.businessType)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Row(
                                    children: [
                                      const CustomText('تصنيف النشاط: '),
                                      Expanded(
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return CustomTextFormField(
                                              initialValue: _initialValue.businessCategory,
                                              onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(businessCategory: txt),
                                              validator: (txt) => ref.read(_modelProvider.select((model) => model.businessCategory)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                              decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: 'اختر صورة', type: FileType.image);
                                if (result == null) return;
                                ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(scanner: result.files.first.path);
                              },
                              child: const Text('تحميل صورة للمستند'),
                            ),
                            const SizedBox(height: 16),
                            Consumer(
                              builder: (context, ref, _) {
                                final imagePath = ref.watch(_modelProvider.select((model) => model.scanner));
                                if (imagePath == null || imagePath.isEmpty) return Container();
                                return ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
                                  child: Stack(
                                    children: [
                                      Image.file(File(imagePath)),
                                      IconButton(
                                        onPressed: () => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(scanner: ''),
                                        icon: const Icon(Icons.delete_outline),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: CustomText('مختار المحلة'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000, minWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(padding: EdgeInsets.all(8.0), child: Divider()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: () async {
                          Scaffold.of(context).showBottomSheet(
                            (_) => const SizedBox(
                              height: 64,
                              width: 256,
                              child: Center(child: CustomText('تم الحفظ بنجاح')),
                            ),
                          );
                          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));

                          if (_formKey.currentState?.validate() == true) {
                            var model = ref.read(_modelProvider);
                            if (model.ownerName.trim().isNotEmpty ||
                                model.ownerPhone.trim().isNotEmpty ||
                                model.tenantName.trim().isNotEmpty ||
                                model.tenantPhone.trim().isNotEmpty ||
                                model.streetCode.trim().isNotEmpty ||
                                model.shopNo.trim().isNotEmpty ||
                                model.businessType.trim().isNotEmpty ||
                                model.businessCategory.trim().isNotEmpty) {
                              if (model.scanner?.isNotEmpty == true) {
                                model = model.copyWith(scanner: await FileManager.saveImage(model.scanner!));
                              }
                              modelController.save(model).then((value) {
                                showModalBottomSheet(context: context, builder: (_) => const CustomText('تم الحفظ بنجاح'));
                                Navigator.pop(context);
                                // TODO: reload list in home page
                                // ref.invalidate(allModels);
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const CustomText('حفظ'),
                      );
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
