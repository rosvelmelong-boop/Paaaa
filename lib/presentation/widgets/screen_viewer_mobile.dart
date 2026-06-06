import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScreenViewer extends StatefulWidget {
  final String fileName;
  final Function(Map<String, dynamic> navigationData) onNavigate;

  const ScreenViewer({
    super.key,
    required this.fileName,
    required this.onNavigate,
  });

  @override
  State<ScreenViewer> createState() => _ScreenViewerState();
}

class _ScreenViewerState extends State<ScreenViewer> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _htmlContent;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A1628))
      ..addJavaScriptChannel(
        'NavigationChannel',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final data = jsonDecode(message.message) as Map<String, dynamic>;
            widget.onNavigate(data);
          } catch (e) {
            debugPrint("Error parsing message from webview: $e");
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      );

    _loadHtml();
  }

  @override
  void didUpdateWidget(covariant ScreenViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileName != widget.fileName) {
      setState(() {
        _isLoading = true;
      });
      _loadHtml();
    }
  }

  Future<void> _loadHtml() async {
    try {
      String html = await rootBundle.loadString('assets/screens/${widget.fileName}');
      String js = await rootBundle.loadString('assets/screens/nav_interceptor.js');
      
      // Remove any relative or absolute external references to nav_interceptor.js
      html = html.replaceAll('<script src="nav_interceptor.js"></script>', '');
      html = html.replaceAll('<script src="/nav_interceptor.js"></script>', '');
      
      if (html.contains('</body>')) {
        html = html.replaceFirst('</body>', '<script>\n$js\n</script></body>');
      } else {
        html = '$html<script>\n$js\n</script>';
      }

      setState(() {
        _htmlContent = html;
      });

      await _controller.loadHtmlString(html);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _htmlContent = '<h3>Error loading screen: ${widget.fileName}</h3><p>$e</p>';
      });
      await _controller.loadHtmlString(_htmlContent!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D9A8A)),
            ),
          ),
      ],
    );
  }
}
