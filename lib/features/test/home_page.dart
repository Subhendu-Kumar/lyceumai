import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lyceumai/core/utils.dart';
import 'package:lyceumai/features/test/audio_wave.dart';
import 'package:lyceumai/features/test/test_api_call.dart';
import 'package:lyceumai/features/test/test_response.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? selectedAudio;
  bool isLoading = false;
  TestResponse? testResponse;

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
        testResponse = null;
        isLoading = false;
      });
    }
  }

  Future<void> submitAnswer() async {
    setState(() => isLoading = true);
    TestResponse? result = await fetchFeedback(selectedAudio!);
    setState(() {
      isLoading = false;
      testResponse = result;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Assignment Test"),
        actions: [
          IconButton(
            icon: Icon(Icons.input),
            onPressed: () {
              if (selectedAudio == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select an audio file first.")),
                );
                return;
              }
              submitAnswer();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "What is the difference between a process and a thread in an operating system?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Hint: Tap the button below to start recording.",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              selectedAudio != null
                  ? AudioWave(path: selectedAudio!.path)
                  : Container(),
              SizedBox(height: 20),
              Center(
                child: isLoading
                    ? Expanded(child: _buildSkeletonCards())
                    : testResponse != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Feedback"),
                          _buildCard(
                            title: "Score",
                            content: testResponse!.score.toString(),
                            color: Colors.blue.shade100,
                          ),
                          _buildCard(
                            title: "Feedback",
                            content: testResponse!.feedback,
                            color: Colors.green.shade100,
                          ),
                          _buildCard(
                            title: "Strengths",
                            content: testResponse!.strengths.join(", "),
                            color: Colors.orange.shade100,
                          ),
                          _buildCard(
                            title: "Areas for Improvement",
                            content: testResponse!.areasForImprovement.join(
                              ", ",
                            ),
                            color: Colors.red.shade100,
                          ),
                          SizedBox(height: 40),
                        ],
                      )
                    : Text("Submit an answer to see feedback"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectAudio,
        child: Icon(Icons.mic),
      ),
    );
  }

  Widget _buildSkeletonCards() {
    return ListView.builder(
      shrinkWrap: true, // ✅ allows ListView inside Column
      physics:
          const NeverScrollableScrollPhysics(), // ✅ avoid conflict if parent scrolls
      itemCount: 4, // number of skeleton cards
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.purple[50]!,
            highlightColor: Colors.grey[200]!,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 18, width: 120, color: Colors.purple[50]),
                  const SizedBox(height: 10),
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.purple[100],
                  ),
                  const SizedBox(height: 6),
                  Container(height: 14, width: 200, color: Colors.purple[50]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({
    required String title,
    required String content,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: color,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(content, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
