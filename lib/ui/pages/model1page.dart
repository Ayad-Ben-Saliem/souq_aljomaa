import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';
import 'package:souq_aljomaa/ui/file_preview.dart';
import 'package:souq_aljomaa/ui/pages/home_page/home_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

final _modelProvider = StateProvider((ref) => _initialValue);

final _formKey = GlobalKey<FormState>();

final _emptyValue = Model1(
  locality: '',
  witness: '',
  responsible: '',
  firstName: '',
  fatherName: '',
  grandfatherName: '',
  lastName: '',
  motherName: '',
  identifierNo: '',
  nationalId: '',
  testimony: '',
  date: DateTime.now(),
);
var _initialValue = _emptyValue;

class Model1Page extends ConsumerStatefulWidget {
  final Model1? model;

  const Model1Page({super.key, this.model});

  @override
  ConsumerState<Model1Page> createState() => _Model1PageState();
}

class _Model1PageState extends ConsumerState<Model1Page> {
  @override
  void initState() {
    super.initState();

    final model = widget.model;
    if (model != null) {
      _initialValue = model.copyWith();
    } else {
      _initialValue = _emptyValue.copyWith(
        locality: sharedPreferences.getString('locality'),
        witness: sharedPreferences.getString('witness'),
        responsible: sharedPreferences.getString('responsible'),
      );
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText('محلة: '),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 128),
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.locality,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(locality: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.locality)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Consumer(
                                builder: (context, ref, child) => CustomText(ref.read(_modelProvider).documentTitle),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText('يشهد: '),
                                Flexible(
                                  flex: 2,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.witness,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(witness: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.witness)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                                const CustomText('مختار محلة: '),
                                Flexible(
                                  flex: 1,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.responsible,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(responsible: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.responsible)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText('بأن السيد: '),
                                Flexible(
                                  flex: 1,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.firstName,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(firstName: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.firstName)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                                const CustomText('اسم الأب: '),
                                Flexible(
                                  flex: 1,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.fatherName,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(fatherName: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.fatherName)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                                const CustomText('اسم الجد: '),
                                Flexible(
                                  flex: 1,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.grandfatherName,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(grandfatherName: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.grandfatherName)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                                const CustomText('اللقب: '),
                                Flexible(
                                  flex: 1,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.lastName,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(lastName: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.lastName)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText('اسم الأم ثلاثي: '),
                                Flexible(
                                  flex: 2,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.motherName,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(motherName: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.motherName)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                                const CustomText('الحامل للإثبات الشخصي رقم: '),
                                Flexible(
                                  flex: 1,
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.identifierNo,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(identifierNo: txt),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText('الرقم الوطني: '),
                                Flexible(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.nationalId,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(nationalId: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.nationalId)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText('مقيم بهذه المحلة وأنه: '),
                                Flexible(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.testimony,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(testimony: txt),
                                        validator: (txt) => ref.read(_modelProvider.select((model) => model.testimony)).trim().isEmpty ? 'هذا الحقل مطلوب' : null,
                                        decoration: const InputDecoration(errorStyle: TextStyle(fontSize: 18)),
                                        maxLines: null,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: CustomText('لصحة ما ذكر أعلاه أعطيت له هذه الإفادة بناء على طلبه لاستعمالها فيما يسمح به القانون'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    const CustomText('التاريخ (هجري)'),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 256),
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          return JGlobalDatePicker(
                                            widgetType: WidgetType.JContainer,
                                            pickerType: PickerType.JHijri,
                                            buttons: const SizedBox(),
                                            primaryColor: Theme.of(context).colorScheme.primary,
                                            calendarTextColor: Theme.of(context).colorScheme.onSurface,
                                            backgroundColor: Theme.of(context).colorScheme.surface,
                                            borderRadius: const Radius.circular(10),
                                            headerTitle: const Center(
                                              child: Text("التقويم الهجري"),
                                            ),
                                            startDate: JDateModel(dateTime: DateTime.parse("1984-12-24")),
                                            selectedDate: JDateModel(dateTime: ref.watch(_modelProvider.select((model) => model.date))),
                                            endDate: JDateModel(dateTime: DateTime.parse("2030-09-20")),
                                            pickerMode: DatePickerMode.day,
                                            pickerTheme: Theme.of(context),
                                            textDirection: TextDirection.rtl,
                                            onChange: (val) {
                                              final model = ref.read(_modelProvider);
                                              ref.read(_modelProvider.notifier).state = model.copyWith(date: val.date);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const CustomText('الموافق (ميلادي)'),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 256),
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          return SfDateRangePicker(
                                            initialSelectedDate: ref.watch(_modelProvider.select((model) => model.date)),
                                            onSelectionChanged: (selection) {
                                              final model = ref.read(_modelProvider);
                                              ref.read(_modelProvider.notifier).state = model.copyWith(date: selection.value);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
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
                    child: Consumer(builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            var model = ref.read(_modelProvider);
                            if (model.locality.trim().isNotEmpty ||
                                model.witness.trim().isNotEmpty ||
                                model.responsible.trim().isNotEmpty ||
                                model.firstName.trim().isNotEmpty ||
                                model.fatherName.trim().isNotEmpty ||
                                model.grandfatherName.trim().isNotEmpty ||
                                model.lastName.trim().isNotEmpty ||
                                model.motherName.trim().isNotEmpty ||
                                model.nationalId.trim().isNotEmpty ||
                                model.testimony.trim().isNotEmpty) {
                              // Used with local storage
                              // final docs = [for (final doc in model.documents) await FileManager.saveImage(doc)];
                              // model = model.copyWith(documents: docs);

                              modelController.saveModel(model).then((value) {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: CustomText('تم الحفظ بنجاح')));

                                HomePage.refresh(ref);
                              });

                              sharedPreferences.setString('locality', model.locality);
                              sharedPreferences.setString('witness', model.witness);
                              sharedPreferences.setString('responsible', model.responsible);
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
