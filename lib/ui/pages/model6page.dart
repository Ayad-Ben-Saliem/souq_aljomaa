import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/models/model6.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';
import 'package:souq_aljomaa/ui/file_preview.dart';
import 'package:souq_aljomaa/ui/pages/home_page/home_page.dart';

final _modelProvider = StateProvider((ref) => _initialValue);

final _formKey = GlobalKey<FormState>();

final _emptyValue = Model6(
  ownerName: '',
  ownerPhone: '',
  tenantName: '',
  tenantPhone: '',
  streetCode: '',
  shopNo: '',
  businessType: '',
  businessCategory: '',
);
var _initialValue = _emptyValue;

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

    _initialValue = widget.model == null ? _emptyValue : widget.model!.copyWith();

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
                            Image.asset('assets/images/header.jpg'),
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
                                              validator: (txt) => ref.read(_modelProvider).ownerName.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                              validator: (txt) => ref.read(_modelProvider).ownerPhone.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                              validator: (txt) => ref.read(_modelProvider).tenantName.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                              validator: (txt) => ref.read(_modelProvider).tenantPhone.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                              validator: (txt) => ref.read(_modelProvider).streetCode.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                              validator: (txt) => ref.read(_modelProvider).shopNo.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                              validator: (txt) => ref.read(_modelProvider).businessType.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                              validator: (txt) => ref.read(_modelProvider).businessCategory.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
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
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  dialogTitle: 'اختر مستند',
                                  type: FileType.image,
                                );
                                if (result == null || result.files.isEmpty) return;

                                final documents = List.of(ref.read(_modelProvider).documents);
                                for (final file in result.files) {
                                  if (file.path != null)documents.add(file.path!);
                                }

                                ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(documents: documents);
                              },
                              child: const Text('تحميل مستندات'),
                            ),
                            const SizedBox(height: 16),
                            Consumer(
                              builder: (context, ref, _) {
                                final documents = ref.watch(_modelProvider.select((model) => model.documentsUrl));
                                if (documents.isEmpty) return Container();

                                return Wrap(
                                  children: [
                                    for (var index = 0; index < documents.length; index++)
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
                                        child: Stack(
                                          children: [
                                            Center(child: FilePreview(documents.elementAt(index))),
                                            IconButton(
                                              onPressed: () {
                                                final docs = List.of(ref.read(_modelProvider).documents);
                                                docs.removeAt(index);
                                                ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(documents: docs);
                                              },
                                              icon: const Icon(Icons.delete_outline),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
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
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed: () async {
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
                                // Used with local storage
                                // final docs = [for (final doc in model.documents) await FileManager.saveImage(doc)];
                                // model = model.copyWith(documents: docs);

                                modelController.saveModel(model).then((value) {
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: CustomText('تم الحفظ بنجاح')));

                                  HomePage.refresh(ref);
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
                      },
                    ),
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
