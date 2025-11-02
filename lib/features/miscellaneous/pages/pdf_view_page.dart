// lib/features/miscellaneous/pages/pdf_view_page.dart

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatelessWidget {
  final String title;
  final String pdfUrl;
  const PdfViewPage({super.key, required this.pdfUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
