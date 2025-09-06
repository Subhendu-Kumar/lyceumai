import 'package:flutter/widgets.dart';

class ClassroomOverviewPage extends StatefulWidget {
  final String id;
  const ClassroomOverviewPage({super.key, required this.id});

  @override
  State<ClassroomOverviewPage> createState() => _ClassroomOverviewPageState();
}

class _ClassroomOverviewPageState extends State<ClassroomOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Classroom Overview Page ${widget.id}"));
  }
}
