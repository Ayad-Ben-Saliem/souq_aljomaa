import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/models/model7.dart';
import 'package:souq_aljomaa/storage/file_manager.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';
import 'package:souq_aljomaa/ui/home_page.dart';

final _modelProvider = StateProvider((ref) => _initialValue);

final _formKey = GlobalKey<FormState>();

var _initialValue = Model7(
  streetNo: '',
  buildingNo: '',
  registrationNo: '',
  familyHeadName: '',
  malesCount: 0,
  femalesCount: 0,
  formFiller: const FormFiller(name: '', phoneNo: ''),
);

class Model7Page extends ConsumerStatefulWidget {
  final Model7? model;

  const Model7Page({super.key, this.model});

  @override
  ConsumerState<Model7Page> createState() => _Model7PageState();
}

class _Model7PageState extends ConsumerState<Model7Page> {
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
                            Image.asset('assets/images/header.jpg'),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('رقم الشارع: ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.streetNo,
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(streetNo: txt),
                                    validator: (txt) => ref.read(_modelProvider).streetNo.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('رقم المبنى: ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.buildingNo,
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(buildingNo: txt),
                                    validator: (txt) => ref.read(_modelProvider).buildingNo.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('رقم القيد: ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.registrationNo,
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(registrationNo: txt),
                                    validator: (txt) => ref.read(_modelProvider).registrationNo.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('اسم رب الأسرة (رباعي): ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.familyHeadName,
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(familyHeadName: txt),
                                    validator: (txt) => ref.read(_modelProvider).familyHeadName.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('عدد أفراد الأسرة: ')),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.malesCount.toString(),
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(malesCount: int.tryParse(txt)),
                                    // validator: (txt) => ref.read(_modelProvider).malesCount.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('ذكور')),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.femalesCount.toString(),
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(femalesCount: int.tryParse(txt)),
                                    // validator: (txt) => ref.read(_modelProvider).femalesCount.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('إناث')),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 150, child: CustomText('الأرامل: ')),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxHeight: 250),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(child: _widowsForm()),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 32),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final model = ref.read(_modelProvider);
                                                final widows = [...model.widows, const Widow(malesCount: 0, femalesCount: 0)];
                                                ref.read(_modelProvider.notifier).state = model.copyWith(widows: widows);
                                              },
                                              child: const Text('إضافة'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 150, child: CustomText('المطلقات: ')),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxHeight: 250),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(child: _divorcedForm()),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 32),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final model = ref.read(_modelProvider);
                                                final divorced = [...model.divorced, const Divorced(malesCount: 0, femalesCount: 0)];
                                                ref.read(_modelProvider.notifier).state = model.copyWith(divorced: divorced);
                                              },
                                              child: const Text('إضافة'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 150, child: CustomText('أصحاب الدخل المحدود: ')),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxHeight: 250),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(child: _lowIncomeForm()),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 32),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final model = ref.read(_modelProvider);
                                                final lowIncome = [...model.lowIncome, const LowIncome(type: LowIncomeType.employee)];
                                                ref.read(_modelProvider.notifier).state = model.copyWith(lowIncome: lowIncome);
                                              },
                                              child: const Text('إضافة'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 150, child: CustomText('عدد الأفراد الباحثين عن عمل: ')),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxHeight: 250),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(child: _unemployedForm()),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 32),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final model = ref.read(_modelProvider);
                                                final unemployed = [...model.unemployed, const Unemployed(gender: Gender.male, qualification: Qualification.none)];
                                                ref.read(_modelProvider.notifier).state = model.copyWith(unemployed: unemployed);
                                              },
                                              child: const Text('إضافة'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('ذوي الاحتياجات الخاصة: ')),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.disabilities?.malesCount.toString() ?? '',
                                    onChanged: (txt) {
                                      final model = ref.read(_modelProvider);
                                      final malesCount = int.tryParse(txt);
                                      final disabilities = model.disabilities?.copyWith(malesCount: malesCount) ?? Disabilities(malesCount: malesCount ?? 0, femalesCount: 0);
                                      ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(disabilities: disabilities);
                                    },
                                    // validator: (txt) => ref.read(_modelProvider).malesCount.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('ذكور')),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.disabilities?.femalesCount.toString() ?? '',
                                    onChanged: (txt) {
                                      final model = ref.read(_modelProvider);
                                      final femalesCount = int.tryParse(txt);
                                      final disabilities = model.disabilities?.copyWith(malesCount: femalesCount) ?? Disabilities(malesCount: 0, femalesCount: femalesCount ?? 0);
                                      ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(disabilities: disabilities);
                                    },
                                    // validator: (txt) => ref.read(_modelProvider).femalesCount.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('إناث')),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('تاريخ وفاة رب الأسرة: ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: DateTimeFormField(
                                    firstDate: DateTime(1975),
                                    lastDate: DateTime.now(),
                                    initialValue: _initialValue.familyHeadDeathDate,
                                    mode: DateTimeFieldPickerMode.date,
                                    decoration: const InputDecoration(labelText: 'Enter Date'),
                                    onChanged: (date) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(familyHeadDeathDate: date),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('اسم رب الأسرة الحالي: ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.currentFamilyHeadName,
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(currentFamilyHeadName: txt),
                                    validator: (txt) {
                                      final familyHeadDeathDate = ref.read(_modelProvider).familyHeadDeathDate;
                                      if (familyHeadDeathDate == null) return null;
                                      final currentFamilyHeadName = ref.read(_modelProvider).currentFamilyHeadName;
                                      if (currentFamilyHeadName == null) return 'هذا الحقل مطلوب';
                                      return null;
                                    },
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('بيانات مدخل البيانات: ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.formFiller.name,
                                    onChanged: (txt) {
                                      final model = ref.read(_modelProvider);
                                      ref.read(_modelProvider.notifier).state = model.copyWith(formFiller: model.formFiller.copyWith(name: txt));
                                    },
                                    validator: (txt) => ref.read(_modelProvider).formFiller.name.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), labelText: 'الاسم'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.formFiller.phoneNo,
                                    onChanged: (txt) {
                                      final model = ref.read(_modelProvider);
                                      ref.read(_modelProvider.notifier).state = model.copyWith(formFiller: model.formFiller.copyWith(phoneNo: txt));
                                    },
                                    validator: (txt) => ref.read(_modelProvider).formFiller.phoneNo.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), labelText: 'رقم الهاتف'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 150, child: CustomText('ملاحظات: ')),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomTextFormField(
                                    initialValue: _initialValue.notes,
                                    onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(notes: txt),
                                    decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), labelText: 'ملاحظات'),
                                    minLines: 3,
                                    maxLines: 1000,
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
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() == true) {
                              var model = ref.read(_modelProvider);
                              if (model.streetNo.trim().isNotEmpty ||
                                  model.buildingNo.trim().isNotEmpty ||
                                  model.registrationNo.trim().isNotEmpty ||
                                  model.familyHeadName.trim().isNotEmpty ||
                                  model.formFiller.name.trim().isNotEmpty ||
                                  model.formFiller.phoneNo.trim().isNotEmpty) {
                                if (model.scanner?.isNotEmpty == true) {
                                  model = model.copyWith(scanner: await FileManager.saveImage(model.scanner!));
                                }
                                modelController.save(model).then((value) {
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

  Widget _widowRow(Widow widow, int index) {
    // final nameController = TextEditingController(text: widow.name);
    // final malesCountController = TextEditingController(text: widow.malesCount.toString());
    // final femalesCountController = TextEditingController(text: widow.femalesCount.toString());

    print(widow.malesCount);
    print(widow.femalesCount);

    return Row(
      children: [
        Flexible(
          child: CustomTextFormField(
            initialValue: widow.name,
            // controller: nameController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('الاسم')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final widows = List<Widow>.from(model.widows);
              widows.removeAt(index);
              widows.insert(index, widow.copyWith(name: txt));
              ref.read(_modelProvider.notifier).state = model.copyWith(widows: widows);
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: CustomTextFormField(
            initialValue: widow.malesCount.toString(),
            // controller: malesCountController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('ذكور')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final widows = List<Widow>.from(model.widows);
              widows.removeAt(index);
              widows.insert(index, widow.copyWith(malesCount: int.tryParse(txt)));
              ref.read(_modelProvider.notifier).state = model.copyWith(widows: widows);
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: CustomTextFormField(
            initialValue: widow.malesCount.toString(),
            // controller: femalesCountController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('إناث')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final widows = List<Widow>.from(model.widows);
              widows.removeAt(index);
              widows.insert(index, widow.copyWith(femalesCount: int.tryParse(txt)));
              ref.read(_modelProvider.notifier).state = model.copyWith(widows: widows);
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final model = ref.read(_modelProvider);
            final widows = List<Widow>.from(model.widows);
            widows.removeAt(index);
            ref.read(_modelProvider.notifier).state = model.copyWith(widows: widows);
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _widowsForm() {
    return SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, _) {
          final widows = ref.watch(_modelProvider.select((model) => model.widows));

          return Column(
            children: [for (int index = 0; index < widows.length; index++) _widowRow(widows[index], index)],
          );
        },
      ),
    );
  }

  Widget _divorcedRow(Divorced divorced, int index) {
    // final nameController = TextEditingController(text: divorced.name);
    // final malesCountController = TextEditingController(text: divorced.malesCount.toString());
    // final femalesCountController = TextEditingController(text: divorced.femalesCount.toString());

    return Row(
      children: [
        Flexible(
          child: CustomTextFormField(
            initialValue: divorced.name,
            // controller: nameController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('الاسم')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final divorcedList = List<Divorced>.from(model.divorced);
              divorcedList.removeAt(index);
              divorcedList.insert(index, divorced.copyWith(name: txt));
              ref.read(_modelProvider.notifier).state = model.copyWith(divorced: divorcedList);
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: CustomTextFormField(
            initialValue: divorced.malesCount.toString(),
            // controller: malesCountController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('ذكور')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final divorcedList = List<Divorced>.from(model.divorced);
              divorcedList.removeAt(index);
              divorcedList.insert(index, divorced.copyWith(malesCount: int.tryParse(txt)));
              ref.read(_modelProvider.notifier).state = model.copyWith(divorced: divorcedList);
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: CustomTextFormField(
            initialValue: divorced.femalesCount.toString(),
            // controller: femalesCountController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('إناث')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final divorcedList = List<Divorced>.from(model.divorced);
              divorcedList.removeAt(index);
              divorcedList.insert(index, divorced.copyWith(femalesCount: int.tryParse(txt)));
              ref.read(_modelProvider.notifier).state = model.copyWith(divorced: divorcedList);
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final model = ref.read(_modelProvider);
            final divorced = List<Divorced>.from(model.divorced);
            divorced.removeAt(index);
            ref.read(_modelProvider.notifier).state = model.copyWith(divorced: divorced);
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _divorcedForm() {
    return SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, _) {
          final divorced = ref.watch(_modelProvider.select((model) => model.divorced));

          return Column(
            children: [for (int index = 0; index < divorced.length; index++) _divorcedRow(divorced[index], index)],
          );
        },
      ),
    );
  }

  Widget _lowIncomeRow(LowIncome lowIncome, int index) {
    // final nameController = TextEditingController(text: lowIncome.name);
    // final typeCountController = TextEditingController(text: lowIncome.type.toString());

    return Row(
      children: [
        Flexible(
          child: CustomTextFormField(
            initialValue: lowIncome.name,
            // controller: nameController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('الاسم')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final lowIncomeList = List<LowIncome>.from(model.lowIncome);
              lowIncomeList.removeAt(index);
              lowIncomeList.insert(index, lowIncome.copyWith(name: txt));
              ref.read(_modelProvider.notifier).state = model.copyWith(lowIncome: lowIncomeList);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton2(
            items: [for (final type in LowIncomeType.values) DropdownMenuItem(value: type, child: Text(type.name))],
            value: lowIncome.type,
            customButton: Padding(
              padding: const EdgeInsets.all(34.0),
              child: Text(lowIncome.type.name),
            ),
            onChanged: (LowIncomeType? type) {
              if (type != lowIncome.type) {
                final model = ref.read(_modelProvider);
                final lowIncomeList = List<LowIncome>.from(model.lowIncome);
                lowIncomeList.removeAt(index);
                lowIncomeList.insert(index, lowIncome.copyWith(type: type));
                ref.read(_modelProvider.notifier).state = model.copyWith(lowIncome: lowIncomeList);
              }
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final model = ref.read(_modelProvider);
            final lowIncome = List<LowIncome>.from(model.lowIncome)..removeAt(index);
            ref.read(_modelProvider.notifier).state = model.copyWith(lowIncome: lowIncome);
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _lowIncomeForm() {
    return SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, _) {
          final lowIncome = ref.watch(_modelProvider.select((model) => model.lowIncome));

          return Column(
            children: [for (int index = 0; index < lowIncome.length; index++) _lowIncomeRow(lowIncome[index], index)],
          );
        },
      ),
    );
  }

  Widget __unemployedRow(Unemployed unemployed, int index) {
    // final nameController = TextEditingController(text: unemployed.name);
    // final typeCountController = TextEditingController(text: lowIncome.type.toString());

    return Row(
      children: [
        Flexible(
          child: CustomTextFormField(
            initialValue: unemployed.name,
            // controller: nameController,
            decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18), label: Text('الاسم')),
            onChanged: (txt) {
              final model = ref.read(_modelProvider);
              final unemployedList = List<Unemployed>.from(model.unemployed);
              unemployedList.removeAt(index);
              unemployedList.insert(index, unemployed.copyWith(name: txt));
              ref.read(_modelProvider.notifier).state = model.copyWith(unemployed: unemployedList);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton2(
            items: [for (final gender in Gender.values) DropdownMenuItem(value: gender, child: Text(gender.name))],
            value: unemployed.gender,
            customButton: Padding(
              padding: const EdgeInsets.all(34.0),
              child: Text(unemployed.gender.name),
            ),
            onChanged: (Gender? gender) {
              if (gender != unemployed.gender) {
                final model = ref.read(_modelProvider);
                final unemployedList = List<Unemployed>.from(model.unemployed);
                unemployedList.removeAt(index);
                unemployedList.insert(index, unemployed.copyWith(gender: gender));
                ref.read(_modelProvider.notifier).state = model.copyWith(unemployed: unemployedList);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton2(
            items: [for (final qualification in Qualification.values) DropdownMenuItem(value: qualification, child: Text(qualification.name))],
            value: unemployed.qualification,
            customButton: Padding(
              padding: const EdgeInsets.all(34.0),
              child: Text(unemployed.qualification.name),
            ),
            onChanged: (Qualification? qualification) {
              if (qualification != unemployed.qualification) {
                final model = ref.read(_modelProvider);
                final unemployedList = List<Unemployed>.from(model.unemployed);
                unemployedList.removeAt(index);
                unemployedList.insert(index, unemployed.copyWith(qualification: qualification));
                ref.read(_modelProvider.notifier).state = model.copyWith(unemployed: unemployedList);
              }
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final model = ref.read(_modelProvider);
            final unemployed = List<Unemployed>.from(model.unemployed)..removeAt(index);
            ref.read(_modelProvider.notifier).state = model.copyWith(unemployed: unemployed);
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _unemployedForm() {
    return SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, _) {
          final unemployed = ref.watch(_modelProvider.select((model) => model.unemployed));

          return Column(
            children: [for (int index = 0; index < unemployed.length; index++) __unemployedRow(unemployed[index], index)],
          );
        },
      ),
    );
  }
}
