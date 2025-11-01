import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyceumai/features/classroom/widgets/class_material_card.dart';

import 'package:lyceumai/models/class_materials_model.dart';
import 'package:lyceumai/features/classroom/cubit/classroom_cubit.dart';
import 'package:lyceumai/features/classroom/cubit/materials_cubit.dart';

class SyllabusAndMaterialsPage extends StatefulWidget {
  final String id;
  const SyllabusAndMaterialsPage({super.key, required this.id});

  @override
  State<SyllabusAndMaterialsPage> createState() =>
      _SyllabusAndMaterialsPageState();
}

class _SyllabusAndMaterialsPageState extends State<SyllabusAndMaterialsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ClassroomCubit, ClassroomState>(
                builder: (context, state) {
                  if (state is ClassroomLoading) {
                    return const SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is ClassroomLoaded) {
                    final classroom = state.classrooms;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${classroom.name} Syllabus',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ClassMaterialCard(
                          title: "Syllabus",
                          fileUrl: classroom.syllabusUrl,
                        ),
                      ],
                    );
                  } else if (state is ClassroomError) {
                    return SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Center(child: Text("Error: ${state.error}")),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 30),
              BlocBuilder<MaterialsCubit, MaterialsState>(
                builder: (context, state) {
                  if (state is MaterialsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MaterialsError) {
                    return Center(child: Text("Error: ${state.error}"));
                  } else if (state is MaterialsLoaded) {
                    final List<ClassMaterialsModel> materials = state.materials;
                    if (materials.isEmpty) {
                      return const Center(
                        child: Text("No materials uploaded yet."),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class Materials',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...materials.map((material) {
                          return ClassMaterialCard(
                            title: material.title,
                            fileUrl: material.fileUrl,
                          );
                        }),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
