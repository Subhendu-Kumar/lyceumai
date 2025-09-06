import 'package:flutter/widgets.dart';

class QuizzesPage extends StatefulWidget {
  final String id;
  const QuizzesPage({super.key, required this.id});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Quizzes Page for class ID: ${widget.id}'));
  }
}
