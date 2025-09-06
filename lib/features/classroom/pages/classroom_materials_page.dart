import 'package:flutter/widgets.dart';

class ClassroomMaterialsPage extends StatefulWidget {
  final String id;
  const ClassroomMaterialsPage({super.key, required this.id});

  @override
  State<ClassroomMaterialsPage> createState() => _ClassroomMaterialsPageState();
}

class _ClassroomMaterialsPageState extends State<ClassroomMaterialsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Materials Page for class ID: ${widget.id}'));
  }
}
