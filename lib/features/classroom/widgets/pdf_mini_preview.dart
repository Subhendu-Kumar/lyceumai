// lib/features/classroom/widgets/pdf_mini_preview.dart

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfMiniPreview extends StatelessWidget {
  final String fileUrl;
  const PdfMiniPreview({super.key, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: 150,
        child: ClipRRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.5,
            child: Transform.scale(
              scale: 3.5,
              alignment: Alignment.topCenter,
              child: SfPdfViewer.network(
                fileUrl,
                canShowScrollHead: false,
                canShowScrollStatus: false,
                pageLayoutMode: PdfPageLayoutMode.single,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
