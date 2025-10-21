import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfMiniPreview extends StatelessWidget {
  final String syllabusUrl;
  const PdfMiniPreview({super.key, required this.syllabusUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: 150,
        child: SfPdfViewer.network(
          syllabusUrl,
          canShowScrollHead: false,
          canShowScrollStatus: false,
          pageLayoutMode: PdfPageLayoutMode.single,
        ),
      ),
    );
  }
}
