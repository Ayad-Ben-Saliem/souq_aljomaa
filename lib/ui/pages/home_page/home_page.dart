import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:printing/printing.dart';
import 'package:souq_aljomaa/controllers/restful/restful_model_controller.dart';
import 'package:souq_aljomaa/controllers/restful/restful_user_controller.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model2.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/models/model4.dart';
import 'package:souq_aljomaa/models/model5.dart';
import 'package:souq_aljomaa/models/model6.dart';
import 'package:souq_aljomaa/models/model7.dart';
import 'package:souq_aljomaa/pdf/syncfusion_pdf_builder.dart';
import 'package:souq_aljomaa/ui/app.dart';
import 'package:souq_aljomaa/ui/custom_tab_view.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/file_preview.dart';
import 'package:souq_aljomaa/ui/pages/home_page/drawer.dart';
import 'package:souq_aljomaa/ui/pages/model1page.dart';
import 'package:souq_aljomaa/ui/pages/model2page.dart';
import 'package:souq_aljomaa/ui/pages/model3page.dart';
import 'package:souq_aljomaa/ui/pages/model4page.dart';
import 'package:souq_aljomaa/ui/pages/model5page.dart';
import 'package:souq_aljomaa/ui/pages/model6page.dart';
import 'package:souq_aljomaa/ui/pages/model7page.dart';
import 'package:souq_aljomaa/utils.dart';

final userController = RestfulUserController();
final modelController = RestfulModelController();

final searchText = StateProvider((ref) => '');

final currentModel = StateProvider<BaseModel?>((ref) => null);

final pdfController = PdfViewerController();

final pagingController = PagingController<int, BaseModel>(firstPageKey: 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();

  static void refresh(WidgetRef ref) {
    ref.read(currentModel.notifier).state = null;
    pagingController.refresh();
  }
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _pageSize = 10;

  @override
  void initState() {
    pagingController.addPageRequestListener(_fetchData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchText, (previous, next) => HomePage.refresh(ref));
    return Scaffold(
      drawer: const HomePageDrawer(),
      body: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 512),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: const Icon(Icons.menu),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchBar(
                          onChanged: (txt) {
                            ref.read(searchText.notifier).state = txt;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: () => pagingController.refresh(), icon: const Icon(Icons.refresh)),
                    ),
                  ],
                ),
                Flexible(
                  child: PagedListView<int, BaseModel>(
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate<BaseModel>(
                      animateTransitions: true,
                      itemBuilder: (context, model, index) => ModelListTile(model: model),
                      firstPageErrorIndicatorBuilder: (context) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomText('ابحث لعرض النتائج'),
                          ),
                        );
                      },
                      newPageErrorIndicatorBuilder: (context) => Container(),
                      noItemsFoundIndicatorBuilder: (context) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomText('لا يوجد نماذج لعرضها'),
                          ),
                        );
                      },
                      noMoreItemsIndicatorBuilder: (context) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CustomText('لا يوجد المزيد من النماذج لعرضها'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final model = ref.watch(currentModel);
                if (model == null) return const Center(child: CustomText('اختر نموذج لعرضه'));

                return FutureBuilder(
                  future: SyncfusionPdfBuilder.getDocument(model),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          final bytes = snapshot.requireData;
                          return _pdfPage(bytes, model);
                        } else if (snapshot.hasError) {
                          return Column(
                            children: [
                              CustomText('${snapshot.error}'),
                              const Divider(),
                              CustomText('${snapshot.stackTrace}'),
                            ],
                          );
                        } else {
                          return const Center(child: CustomText('لا يوجد بيانات!!!'));
                        }
                      case ConnectionState.none:
                        return Container();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ref.watch(currentUser)?.canModifyModels == true ? addModelsButton() : null,
    );
  }

  Widget addModelsButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CustomText('اختر نموذجاً'),
                    ),
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _button(context, Model1.title, const Model1Page()),
                        _button(context, Model2.title, const Model2Page()),
                        _button(context, Model3.title, const Model3Page()),
                        _button(context, Model4.title, const Model4Page()),
                        _button(context, Model5.title, const Model5Page()),
                        _button(context, Model6.title, const Model6Page()),
                        _button(context, Model7.title, const Model7Page()),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.add),
    );
  }

  Widget _pdfPage(Uint8List bytes, BaseModel model) {
    return CustomTabView(
      isScrollable: false,
      itemCount: model.documentsUrl.length + 1,
      tabBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Printing.layoutPdf(onLayout: (format) => bytes, name: model.documentTitle),
                  icon: const Icon(Icons.print_outlined),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => pdfController.setZoom(pdfController.centerPosition, pdfController.currentZoom + 1),
                  icon: const Icon(Icons.zoom_in),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => pdfController.setZoom(pdfController.centerPosition, pdfController.currentZoom - 1),
                  icon: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          );
        }
        return SizedBox(height: kToolbarHeight, child: Center(child: CustomText('المستند ($index)')));
      },
      pageBuilder: (context, index) {
        if (index == 0) {
          return PdfViewer.data(
            bytes,
            sourceName: model.documentTitle,
            controller: pdfController,
            params: PdfViewerParams(
              backgroundColor: Theme.of(context).colorScheme.surface,
              pageAnchor: PdfPageAnchor.all,
            ),
          );
        }
        return FilePreview(model.documentsUrl.elementAt(index - 1));
      },
    );
  }

  Widget _button(BuildContext context, String title, Widget page) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context)
          ..pop()
          ..push(MaterialPageRoute(builder: (_) => page)),
        child: CustomText(title),
      ),
    );
  }

  void _fetchData(int pageKey) async {
    final showAllData = sharedPreferences.getBool('showAllData') == true;
    String? text = ref.read(searchText);
    if (!showAllData && text?.isEmpty == true) {
      text = null;
    }

    try {
      final models = await modelController.search(
        searchText: text,
        limit: _pageSize,
        offset: pageKey,
      );
      if (models.isEmpty) {
        pagingController.appendLastPage(models.toList());
      } else {
        pagingController.appendPage(models.toList(), pageKey + models.length);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

// @override
// void dispose() {
//   // pagingController.dispose();
//   super.dispose();
// }
}

class ModelListTile extends StatelessWidget {
  final BaseModel model;

  const ModelListTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final model = this.model;
    String title = '';
    String trailing = '';
    Widget editPage = Container();
    if (model is Model1) {
      title = '${model.fullName} (${model.id})';
      trailing = model.documentTitle;
      editPage = Model1Page(model: model);
    } else if (model is Model2) {
      title = model.fullName;
      trailing = model.documentTitle;
      editPage = Model2Page(model: model);
    } else if (model is Model3) {
      title = model.fullName;
      trailing = model.documentTitle;
      editPage = Model3Page(model: model);
    } else if (model is Model4) {
      title = model.fullName;
      trailing = model.documentTitle;
      editPage = Model4Page(model: model);
    } else if (model is Model5) {
      title = model.fullName;
      trailing = model.documentTitle;
      editPage = Model5Page(model: model);
    } else if (model is Model6) {
      title = '${model.ownerName} : ${model.tenantName}';
      trailing = model.documentTitle;
      editPage = Model6Page(model: model);
    } else if (model is Model7) {
      title = '${model.familyHeadName} (${model.registrationNo})';
      trailing = model.documentTitle;
      editPage = Model7Page(model: model);
    } else {
      throw Exception('Not implemented model');
    }

    return Consumer(
      builder: (context, ref, _) {
        final canModifyModels = ref.watch(currentUser)?.canModifyModels == true;
        return InkWell(
          onTap: () {
            if (ref.read(currentModel) == model) {
              ref.read(currentModel.notifier).state = null;
            } else {
              ref.read(currentModel.notifier).state = model;
            }
          },
          onDoubleTap: canModifyModels ? () => navigateToPage(context, editPage) : null,
          child: ListTile(
            title: CustomText(title),
            subtitle: CustomText(trailing, style: const TextStyle(fontSize: 16)),
            trailing: canModifyModels
                ? IconButton(
                    onPressed: () {
                      modelController.deleteModel(model);
                      HomePage.refresh(ref);
                    },
                    icon: const Icon(Icons.delete_outline),
                  )
                : null,
            selected: ref.watch(currentModel) == model,
            selectedTileColor: Colors.blue,
            selectedColor: Colors.white,
          ),
        );
      },
    );
  }
}

void navigateToPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}
