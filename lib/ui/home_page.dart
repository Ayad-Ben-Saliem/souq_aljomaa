import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
import 'package:souq_aljomaa/pdf/pdf_manager.dart';
import 'package:souq_aljomaa/ui/custom_text.dart';
import 'package:souq_aljomaa/ui/pages/model1page.dart';
import 'package:souq_aljomaa/ui/pages/model2page.dart';
import 'package:souq_aljomaa/ui/pages/model3page.dart';
import 'package:souq_aljomaa/ui/pages/model4page.dart';
import 'package:souq_aljomaa/ui/pages/model5page.dart';
import 'package:souq_aljomaa/ui/pages/model6page.dart';
import 'package:souq_aljomaa/ui/pages/model7page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

final modelController = ModelController();

final searchText = StateProvider((ref) => '');

final currentModel = StateProvider<BaseModel?>((ref) => null);

final refreshProvider = StateProvider((ref) => 0);

final controller = StateProvider((ref) => PdfViewerController());

final fitWidth = StateProvider((ref) => false);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();

  static void refresh(WidgetRef ref) {
    final refreshState = ref.read(refreshProvider);
    ref.read(refreshProvider.notifier).state = refreshState + 1;
  }
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _pageSize = 10;

  final _pagingController = PagingController<int, BaseModel>(firstPageKey: 0);

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
  void initState() {
    _pagingController.addPageRequestListener(_fetchData);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(refreshProvider, (previous, next) => _pagingController.refresh());
    ref.listen(searchText, (previous, next) => _pagingController.refresh());
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
          const VerticalDivider(),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final model = ref.watch(currentModel);
                if (model == null) return const Center(child: Text('اختر نموذج لعرضه', style: TextStyle(fontSize: 24)));
                if (Platform.isLinux) {
                  return PdfPreview(build: (format) => PdfManager.getDocument(model));
                }
                return FutureBuilder(
                  future: PdfManager.getDocument(model),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        final bytes = snapshot.requireData;
                        return _pdfPage(bytes);
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

  Widget _pdfPage(Uint8List bytes) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Printing.layoutPdf(onLayout: (format) => bytes),
              icon: const Icon(Icons.print_outlined),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => Printing.sharePdf(bytes: bytes),
              icon: const Icon(Icons.share),
            ),
            const SizedBox(width: 16),
            Consumer(
              builder: (context, ref, child) {
                return IconButton(
                  onPressed: () {
                    // reset zoomLevel
                    ref.read(controller).zoomLevel = 1;
                    ref.read(fitWidth.notifier).state = !ref.read(fitWidth);
                  },
                  icon: Icon(ref.watch(fitWidth) ? Icons.zoom_in_map : Icons.zoom_out_map),
                );
              },
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => ref.read(controller).zoomLevel = ref.read(controller).zoomLevel + 0.1,
              icon: const Icon(Icons.zoom_in),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => ref.read(controller).zoomLevel = ref.read(controller).zoomLevel - 0.1,
              icon: const Icon(Icons.zoom_out),
            ),
          ],
        ),
        const Divider(),
        Flexible(
          child: Consumer(
            builder: (context, ref, _) {
              final pdfViewer = SfPdfViewer.memory(bytes, controller: ref.read(controller));

              if (ref.watch((fitWidth))) return pdfViewer;
              return LayoutBuilder(
                builder: (context, constraints) {
                  return AspectRatio(aspectRatio: 0.70710678118, child: pdfViewer);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _popAndPushPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _button(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () => _popAndPushPage(context, page),
      child: CustomText(title),
    );
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
                ref.read(refreshProvider.notifier).state = ref.read(refreshProvider) + 1;
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
