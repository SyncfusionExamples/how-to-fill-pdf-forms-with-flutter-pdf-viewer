import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'save_helper.dart' if (dart.library.js_interop) 'save_helper_web.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PdfViewerPage(),
  ));
}

/// The widgt containing the pdf viewer.
class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PdfViewerController _pdfViewerController = PdfViewerController();
  final UndoHistoryController _undoController = UndoHistoryController();
  late List<int> formDataBytes;
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            child: Row(
              children: <Widget>[
                ValueListenableBuilder(
                    valueListenable: _undoController,
                    builder: (context, value, child) {
                      return IconButton(
                        onPressed: _undoController.value.canUndo
                            ? _undoController.undo
                            : null,
                        icon: const Icon(Icons.undo),
                        tooltip: 'Undo', // Add tooltip here
                      );
                    }),
                const SizedBox(width: 10), // Add space between buttons
                ValueListenableBuilder(
                    valueListenable: _undoController,
                    builder: (context, value, child) {
                      return IconButton(
                        onPressed: _undoController.value.canRedo
                            ? _undoController.redo
                            : null,
                        icon: const Icon(Icons.redo),
                        tooltip: 'Redo', // Add tooltip here
                      );
                    }),
                const SizedBox(width: 10), // Add space between buttons
                IconButton(
                  icon: const Icon(
                    Icons.outbox,
                  ),
                  tooltip: 'Export Form Data',
                  onPressed: () async {
                    formDataBytes = _pdfViewerController.exportFormData(
                        dataFormat: DataFormat.xfdf);
                  },
                ),
                const SizedBox(width: 10), // Add space between buttons
                IconButton(
                  icon: const Icon(
                    Icons.inbox,
                  ),
                  tooltip: 'Import Form Data',
                  onPressed: () async {
                    _pdfViewerController.importFormData(
                        formDataBytes, DataFormat.xfdf);
                  },
                ),
                const SizedBox(width: 10), // Add space between buttons
                IconButton(
                  icon: const Icon(
                    Icons.save,
                  ),
                  tooltip: 'Save Document',
                  onPressed: () async {
                    final List<int> savedBytes =
                        await _pdfViewerController.saveDocument();

                    SaveHelper.save(savedBytes, 'form_document.pdf');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        'assets/form_document.pdf',
        controller: _pdfViewerController,
        undoController: _undoController,
      ),
    );
  }
}
