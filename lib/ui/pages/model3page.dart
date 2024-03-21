import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/custom_text_field.dart';
import 'package:souq_aljomaa/ui/home_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

final _modelProvider = StateProvider((ref) => _initialValue);

final _dateProvider = StateProvider((ref) => DateTime.now());

final _formKey = GlobalKey<FormState>();

var _initialValue = const Model3(
  locality: '',
  witness: '',
  responsible: '',
  firstName: '',
  fatherName: '',
  grandfatherName: '',
  lastName: '',
  identifierNo: '',
  identifierFrom: '',
  nationalId: '',
  testimony: '',
  date1: '',
  date2: '',
);

class Model3Page extends ConsumerStatefulWidget {
  final Model3? model;

  const Model3Page({super.key, this.model});

  @override
  ConsumerState<Model3Page> createState() => _Model3PageState();
}

class _Model3PageState extends ConsumerState<Model3Page> {
  @override
  void initState() {
    super.initState();

    final model = widget.model;
    if (model != null) {
      _initialValue = model.copyWith();
    } else {
      _initialValue = _initialValue.copyWith(
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
                                const CustomText('محلة: '),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 256),
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
                                const CustomText('الحامل للإثبات الشخصي رقم: '),
                                Flexible(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.identifierNo,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(identifierNo: txt),
                                      );
                                    },
                                  ),
                                ),
                                const CustomText('الصادر من: '),
                                Flexible(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      return CustomTextFormField(
                                        initialValue: _initialValue.identifierFrom,
                                        onChanged: (txt) => ref.read(_modelProvider.notifier).state = ref.read(_modelProvider).copyWith(identifierFrom: txt),
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
                                const CustomText('مقيم بهذه المحلة: '),
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
                              padding: EdgeInsets.all(16),
                              child: CustomText('مقيم بالمحلة ويتمتع بحسن السيرة والسلوك'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(16),
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
                                            calendarTextColor: Theme.of(context).colorScheme.onBackground,
                                            backgroundColor: Theme.of(context).colorScheme.background,
                                            borderRadius: const Radius.circular(10),
                                            headerTitle: const Center(
                                              child: Text("التقويم الهجري"),
                                            ),
                                            startDate: JDateModel(dateTime: DateTime.parse("1984-12-24")),
                                            selectedDate: JDateModel(dateTime: ref.watch(_dateProvider)),
                                            endDate: JDateModel(dateTime: DateTime.parse("2030-09-20")),
                                            pickerMode: DatePickerMode.day,
                                            pickerTheme: Theme.of(context),
                                            textDirection: TextDirection.rtl,
                                            onChange: (val) {
                                              ref.read(_dateProvider.notifier).state = val.date;
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
                                            initialSelectedDate: ref.watch(_dateProvider),
                                            onSelectionChanged: (selection) {
                                              ref.read(_dateProvider.notifier).state = selection.value;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                              if (model.locality.trim().isNotEmpty ||
                                  model.witness.trim().isNotEmpty ||
                                  model.responsible.trim().isNotEmpty ||
                                  model.firstName.trim().isNotEmpty ||
                                  model.fatherName.trim().isNotEmpty ||
                                  model.grandfatherName.trim().isNotEmpty ||
                                  model.lastName.trim().isNotEmpty ||
                                  model.nationalId.trim().isNotEmpty ||
                                  model.testimony.trim().isNotEmpty ||
                                  model.date1.isNotEmpty) {
                                model = model.copyWith(
                                  date1: ref.read(_dateProvider).toString(),
                                  date2: JDateModel(dateTime: ref.read(_dateProvider)).jhijri?.fullDate,
                                );

                                modelController.save(model).then((value) {
                                  showModalBottomSheet(context: context, builder: (_) => const CustomText('تم الحفظ بنجاح'));
                                  Navigator.pop(context);
                                  // TODO: reload list in home page
                                  // ref.invalidate(allModels);
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
