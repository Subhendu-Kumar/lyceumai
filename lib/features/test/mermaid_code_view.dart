import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MermaidCodeView extends StatefulWidget {
  const MermaidCodeView({super.key});

  @override
  State<MermaidCodeView> createState() => _MermaidCodeViewState();
}

class _MermaidCodeViewState extends State<MermaidCodeView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    String rawCode =
        "flowchart TD\n    subgraph CPU Instruction Cycle\n        Start((Start)) --> Fetch;\n\n        Fetch[\"1. Fetch Instruction<br/>(from memory address in PC)\"]\n        style Fetch fill:#f9f,stroke:#333,stroke-width:2px\n\n        Decode[\"2. Decode Instruction<br/>(in Control Unit)\"]\n        style Decode fill:#bbf,stroke:#333,stroke-width:2px\n\n        Execute[\"3. Execute Instruction<br/>(in ALU/FPU)\"]\n        style Execute fill:#ccf,stroke:#333,stroke-width:2px\n\n        Store[\"4. Store Result<br/>(in register or memory)\"]\n        style Store fill:#dfd,stroke:#333,stroke-width:2px\n\n        Fetch --> Decode;\n        Decode --> Execute;\n        Execute --> Store;\n        Store --> InterruptCheck{Check for Interrupts};\n\n        InterruptCheck -- \"No\" --> Fetch;\n        InterruptCheck -- \"Yes\" --> HandleInterrupt[Service Interrupt Routine];\n        HandleInterrupt --> Fetch;\n    end";

    // Step 1: Replace `\n` with real line breaks
    String formatted = rawCode.replaceAll("\\n", "\n");

    // Step 2: Replace `\"` with actual quotes
    formatted = formatted.replaceAll("\\\"", "\"");

    formatted = formatted.replaceAllMapped(RegExp(r'\[.*?\]'), (match) {
      String inside = match.group(0)!;
      // Remove ( ... ) inside the brackets
      inside = inside.replaceAll(RegExp(r'\(.*?\)'), '');
      return inside;
    });

    // Optional: trim leading/trailing spaces
    formatted = formatted.trim();

    print(formatted);

    final String mermaidHtml =
        """
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
        <script>
            mermaid.initialize({ startOnLoad: true });
        </script>
    </head>

    <body style="display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; width: 100%;">
        <div class="mermaid">
           $formatted
        </div>
    </body>

    </html>
    """;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(mermaidHtml)
      ..enableZoom(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mermaid Chart")),
      body: Column(
        children: [Expanded(child: WebViewWidget(controller: _controller))],
      ),
    );
  }
}
