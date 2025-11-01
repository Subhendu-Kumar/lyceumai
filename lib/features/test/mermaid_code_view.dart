// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class MermaidCodeView extends StatefulWidget {
//   const MermaidCodeView({super.key});

//   @override
//   State<MermaidCodeView> createState() => _MermaidCodeViewState();
// }

// class _MermaidCodeViewState extends State<MermaidCodeView> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     String rawCode =
//         "flowchart TD\n    subgraph CPU Instruction Cycle\n        Start((Start)) --> Fetch;\n\n        Fetch[\"1. Fetch Instruction<br/>(from memory address in PC)\"]\n        style Fetch fill:#f9f,stroke:#333,stroke-width:2px\n\n        Decode[\"2. Decode Instruction<br/>(in Control Unit)\"]\n        style Decode fill:#bbf,stroke:#333,stroke-width:2px\n\n        Execute[\"3. Execute Instruction<br/>(in ALU/FPU)\"]\n        style Execute fill:#ccf,stroke:#333,stroke-width:2px\n\n        Store[\"4. Store Result<br/>(in register or memory)\"]\n        style Store fill:#dfd,stroke:#333,stroke-width:2px\n\n        Fetch --> Decode;\n        Decode --> Execute;\n        Execute --> Store;\n        Store --> InterruptCheck{Check for Interrupts};\n\n        InterruptCheck -- \"No\" --> Fetch;\n        InterruptCheck -- \"Yes\" --> HandleInterrupt[Service Interrupt Routine];\n        HandleInterrupt --> Fetch;\n    end";

//     // Step 1: Replace `\n` with real line breaks
//     String formatted = rawCode.replaceAll("\\n", "\n");

//     // Step 2: Replace `\"` with actual quotes
//     formatted = formatted.replaceAll("\\\"", "\"");

//     formatted = formatted.replaceAllMapped(RegExp(r'\[.*?\]'), (match) {
//       String inside = match.group(0)!;
//       // Remove ( ... ) inside the brackets
//       inside = inside.replaceAll(RegExp(r'\(.*?\)'), '');
//       return inside;
//     });

//     // Optional: trim leading/trailing spaces
//     formatted = formatted.trim();

//     print(formatted);

//     final String mermaidHtml =
//         """
//     <!DOCTYPE html>
//     <html lang="en">

//     <head>
//         <meta charset="UTF-8">
//         <meta name="viewport" content="width=device-width, initial-scale=1.0">
//         <title>Document</title>
//         <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
//         <script>
//             mermaid.initialize({ startOnLoad: true });
//         </script>
//     </head>

//     <body style="display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; width: 100%;">
//         <div class="mermaid">
//            $formatted
//         </div>
//     </body>

//     </html>
//     """;

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadHtmlString(mermaidHtml)
//       ..enableZoom(true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Mermaid Chart")),
//       body: Column(
//         children: [Expanded(child: WebViewWidget(controller: _controller))],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import "package:http/http.dart" as http;

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isMermaid;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isMermaid = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse("https://lyceumai-be.onrender.com/mermaid/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "query": text,
        }), // adjust if API expects a different key
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final mermaidCode = data["mermaid_code"];
        final description = data["description"];

        setState(() {
          // Show description as normal message
          _messages.add(ChatMessage(text: description, isUser: false));

          // Show Mermaid chart as separate bubble
          _messages.add(
            ChatMessage(text: mermaidCode, isUser: false, isMermaid: true),
          );
        });
      } else {
        setState(() {
          _messages.add(
            ChatMessage(
              text: "⚠️ Error: ${response.statusCode} from server",
              isUser: false,
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: "❌ Failed: $e", isUser: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mermaid Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: msg.isMermaid
                      ? GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MermaidFullScreen(code: msg.text),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 200,
                            height: 300,
                            child: MermaidPreview(code: msg.text),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? Colors.blue.shade100
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg.text),
                        ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _sendMessage(_controller.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small preview box
class MermaidPreview extends StatelessWidget {
  final String code;
  const MermaidPreview({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final String html =
        """
<!DOCTYPE html>
<html>
<head>
  <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
  <script>mermaid.initialize({ startOnLoad: true });</script>
</head>
<body style="margin:0;padding:0;">
  <div class="mermaid">
    $code
  </div>
</body>
</html>
""";

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html);

    return WebViewWidget(controller: controller);
  }
}

/// Fullscreen Mermaid Renderer
class MermaidFullScreen extends StatelessWidget {
  final String code;
  const MermaidFullScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final String html =
        """
          <!DOCTYPE html>
          <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
            <script>mermaid.initialize({ startOnLoad: true });</script>
          </head>
          <body style="margin:0;padding:0;display:flex;justify-content:center;align-items:center;height:100vh;">
            <div class="mermaid" style="width:100%;height:100%;">
              $code
            </div>
          </body>
          </html>
        """;

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html);

    return Scaffold(
      appBar: AppBar(title: const Text("Flowchart")),
      body: WebViewWidget(controller: controller),
    );
  }
}
