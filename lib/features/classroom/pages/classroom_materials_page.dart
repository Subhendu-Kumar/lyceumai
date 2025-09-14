import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/models/class_materials_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:lyceumai/features/classroom/cubit/materials_cubit.dart';

class ClassroomMaterialsPage extends StatefulWidget {
  final String id;
  const ClassroomMaterialsPage({super.key, required this.id});

  @override
  State<ClassroomMaterialsPage> createState() => _ClassroomMaterialsPageState();
}

class _ClassroomMaterialsPageState extends State<ClassroomMaterialsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MaterialsCubit>().getClassMaterials(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<MaterialsCubit, MaterialsState>(
        builder: (context, state) {
          if (state is MaterialsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MaterialsError) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is MaterialsLoaded) {
            final List<ClassMaterialsModel> materials = state.materials;
            if (materials.isEmpty) {
              return const Center(child: Text("No materials uploaded yet."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final material = materials[index];
                return GestureDetector(
                  onTap: () {
                    context.push(
                      "/pdfview",
                      extra: {
                        'pdfUrl': material.fileUrl,
                        'title': "${material.title}.pdf",
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
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
                        // Mini preview of first page
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: SizedBox(
                            height: 150,
                            child: SfPdfViewer.network(
                              material.fileUrl,
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
                              Expanded(
                                child: Text(
                                  material.title,
                                  style: const TextStyle(
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
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
