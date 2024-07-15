import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:printing/printing.dart';
import 'package:souq_aljomaa/controllers/model_controller.dart';
import 'package:souq_aljomaa/models/base_model.dart';
import 'package:souq_aljomaa/models/model1.dart';
import 'package:souq_aljomaa/models/model2.dart';
import 'package:souq_aljomaa/models/model3.dart';
import 'package:souq_aljomaa/models/model4.dart';
import 'package:souq_aljomaa/models/model5.dart';
import 'package:souq_aljomaa/models/model6.dart';
import 'package:souq_aljomaa/models/model7.dart';
import 'package:souq_aljomaa/pdf/syncfusion_pdf_builder.dart';
import 'package:souq_aljomaa/ui/custom_tab_view.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/pages/model1page.dart';
import 'package:souq_aljomaa/ui/pages/model2page.dart';
import 'package:souq_aljomaa/ui/pages/model3page.dart';
import 'package:souq_aljomaa/ui/pages/model4page.dart';
import 'package:souq_aljomaa/ui/pages/model5page.dart';
import 'package:souq_aljomaa/ui/pages/model6page.dart';
import 'package:souq_aljomaa/ui/pages/model7page.dart';

final modelController = ModelController();

final searchText = StateProvider((ref) => '');

final currentModel = StateProvider<BaseModel?>((ref) => null);

final pdfController = PdfViewerController();

final _pagingController = PagingController<int, BaseModel>(firstPageKey: 0);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();

  static void refresh(WidgetRef ref) {
    ref.read(currentModel.notifier).state = null;
    _pagingController.refresh();
  }
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _pageSize = 10;

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchText, (previous, next) => HomePage.refresh(ref));
    return Scaffold(
      body: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 512),
            child: Column(
              children: [
                Row(
                  children: [
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
                      child: IconButton(onPressed: () => _pagingController.refresh(), icon: const Icon(Icons.refresh)),
                    ),
                  ],
                ),
                Flexible(
                  child: PagedListView<int, BaseModel>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<BaseModel>(
                      itemBuilder: (context, model, index) => ModelListTile(model: model),
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
                if (model == null) return const Center(child: Text('اختر نموذج لعرضه', style: TextStyle(fontSize: 24)));

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
                              Text('${snapshot.error}'),
                              const Divider(),
                              Text('${snapshot.stackTrace}'),
                            ],
                          );
                        } else {
                          return const Center(child: Text('لا يوجد بيانات!!!'));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CustomText('اختر نموذجاً'),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 16,
                        children: [
                          _button(context, Model1.title, const Model1Page()),
                          const SizedBox(width: 8),
                          _button(context, Model2.title, const Model2Page()),
                          const SizedBox(width: 8),
                          _button(context, Model3.title, const Model3Page()),
                          const SizedBox(width: 8),
                          _button(context, Model4.title, const Model4Page()),
                          const SizedBox(width: 8),
                          _button(context, Model5.title, const Model5Page()),
                          const SizedBox(width: 8),
                          _button(context, Model6.title, const Model6Page()),
                          const SizedBox(width: 8),
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
      ),
    );
  }

  Widget _pdfPage(Uint8List bytes, BaseModel model) {
    return CustomTabView(
      isScrollable: false,
      itemCount: model.scanner == null ? 1 : 2,
      tabBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    print(bytes.length);
                    Printing.layoutPdf(onLayout: (format) => bytes, name: model.documentTitle);
                  },
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
        return const SizedBox(height: kToolbarHeight, child: Center(child: Text('Scanner Image')));
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
        return Image.file(File(model.scanner!));
      },
    );
  }

  Widget _button(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context)
        ..pop()
        ..push(MaterialPageRoute(builder: (_) => page)),
      child: CustomText(title),
    );
  }

  void _fetchData(int pageKey) async {
    try {
      final models = await modelController.search(
        limit: _pageSize,
        offset: pageKey,
        searchOptions: SearchOptions(ref.read(searchText)),
      );
      if (models.isEmpty) {
        _pagingController.appendLastPage(models.toList());
      } else {
        _pagingController.appendPage(models.toList(), pageKey + models.length);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
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
        return InkWell(
          child: ListTile(
            title: CustomText(title),
            subtitle: Text(trailing, style: const TextStyle(fontSize: 16)),
            trailing: IconButton(
              onPressed: () {
                modelController.deleteModel(model);
                HomePage.refresh(ref);
              },
              icon: const Icon(Icons.delete_outline),
            ),
            selected: ref.watch(currentModel) == model,
            selectedTileColor: Colors.blue,
            selectedColor: Colors.white,
          ),
          onDoubleTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => editPage));
          },
          onTap: () {
            if (ref.read(currentModel) == model) {
              ref.read(currentModel.notifier).state = null;
            } else {
              ref.read(currentModel.notifier).state = model;
            }
          },
        );
      },
    );
  }
}
