// lib/features/classroom/pages/classroom_layout_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassroomLayoutPage extends StatefulWidget {
  final String id;
  final Widget child;
  const ClassroomLayoutPage({super.key, required this.id, required this.child});

  @override
  State<ClassroomLayoutPage> createState() => _ClassroomLayoutPageState();
}

class _ClassroomLayoutPageState extends State<ClassroomLayoutPage> {
  int _currentIndex = 0;
  String _pageTitle = "Overview";

  final List<String> _tabs = ['', 'assignments', 'materials', 'quizzes'];

  final Map<String, String> _tabTitles = {
    '': 'Overview',
    'assignments': 'Assignments',
    'materials': 'Materials',
    'quizzes': 'Quizzes',
  };

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    final tab = _tabs[index];
    setState(() {
      _pageTitle = _tabTitles[tab] ?? '';
    });
    if (tab.isEmpty) {
      context.push('/class/${widget.id}');
    } else {
      context.push('/class/${widget.id}/$tab');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.video_chat, color: Colors.blue),
            onPressed: () {
              context.push('/meetings/${widget.id}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.people_alt, color: Colors.deepPurpleAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTap,
        elevation: 2,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: Colors.blue, fontSize: 12),
        unselectedLabelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Overview",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Assignments",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Materials"),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quizzes"),
        ],
      ),
    );
  }
}
