import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;
  final String title;
  const PdfViewPage({super.key, required this.pdfUrl, required this.title});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: Text(widget.title),
        backgroundColor: Colors.white,
      ),
      body: SfPdfViewer.network(widget.pdfUrl),
    );
  }
}
