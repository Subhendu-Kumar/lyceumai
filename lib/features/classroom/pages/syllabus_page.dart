import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/features/classroom/cubit/classroom_cubit.dart';
import 'package:lyceumai/not_stable/pdf_view_page.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SyllabusPage extends StatefulWidget {
  final String id;
  const SyllabusPage({super.key, required this.id});

  @override
  State<SyllabusPage> createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ClassroomCubit, ClassroomState>(
        builder: (context, state) {
          if (state is ClassroomLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClassroomLoaded) {
            final classroom = state.classrooms;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              // child: Column(
              //   children: [
              //     const Text(
              //       "Syllabus Preview",
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //     ),
              //     const SizedBox(height: 10),

              //     // Small preview box
              //     GestureDetector(
              //       onTap: () {
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (_) => FullPdfViewPage(pdfUrl: syllabusUrl),
              //         //   ),
              //         // );
              //       },
              //       child: Container(
              //         height: 200,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.grey.shade400),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: SfPdfViewer.network(
              //           classroom.syllabusUrl,
              //           canShowScrollHead: false,
              //           canShowScrollStatus: false,
              //           pageLayoutMode: PdfPageLayoutMode.single,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${classroom.name} Syllabus Preview',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => PdfViewPage(
                            pdfUrl: classroom.syllabusUrl,
                            title: "${classroom.name} Syllabus",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: SizedBox(
                              height: 150,
                              child: SfPdfViewer.network(
                                classroom.syllabusUrl,
                                canShowScrollHead: false,
                                canShowScrollStatus: false,
                                pageLayoutMode: PdfPageLayoutMode.single,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.red[900],
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    "syllabus.pdf",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ClassroomError) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
