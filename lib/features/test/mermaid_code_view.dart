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
        "pie\n    title Assumed Population of India (in Billions)\n    \"2022\" : 1.41\n    \"2023\" : 1.42\n    \"2024\" : 1.43";

    // Step 1: Replace `\n` with real line breaks
    String formatted = rawCode.replaceAll("\\n", "\n");

    // Step 2: Replace `\"` with actual quotes
    formatted = formatted.replaceAll("\\\"", "\"");

    // Optional: trim leading/trailing spaces
    formatted = formatted.trim();

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

    <body style="display: flex; flex-direction: column; justify-content: center; align-items: center; height: 70vh; width: 100%;">
        <div class="mermaid">
           $formatted
        </div>
        <p style="margin-top: 20px; font-size: 16px; font-family: sans-serif; text-align: center;">
        This is a pie chart representing the assumed population of India over three consecutive years. 
        The values are illustrative estimates in billions, showing the relative population size for each year.
    </p>
    </body>

    </html>
    """;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(mermaidHtml);
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
