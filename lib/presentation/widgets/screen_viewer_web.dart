import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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
  late final String _viewType;
  html.IFrameElement? _iframe;
  bool _isLoading = true;
  String? _htmlContent;
  dynamic _messageSubscription;

  @override
  void initState() {
    super.initState();
    _viewType = 'propveil-screen-view-${DateTime.now().microsecondsSinceEpoch}';
    
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId, {Object? params}) {
        final iframe = html.IFrameElement()
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        _iframe = iframe;
        
        if (_htmlContent != null) {
          _iframe!.srcdoc = _htmlContent!;
        }
        
        return iframe;
      },
    );

    _messageSubscription = html.window.onMessage.listen((html.MessageEvent event) {
      try {
        final data = jsonDecode(event.data.toString()) as Map<String, dynamic>;
        if (data['type'] == 'navigation') {
          final navData = data['data'] as Map<String, dynamic>;
          widget.onNavigate(navData);
        }
      } catch (e) {
        // Safe to ignore
      }
    });

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

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadHtml() async {
    try {
      String htmlContent = await rootBundle.loadString('assets/screens/${widget.fileName}');
      String js = await rootBundle.loadString('assets/screens/nav_interceptor.js');
      
      if (htmlContent.contains('</body>')) {
        htmlContent = htmlContent.replaceFirst('</body>', '<script>\n$js\n</script></body>');
      } else {
        htmlContent = '$htmlContent<script>\n$js\n</script>';
      }

      setState(() {
        _htmlContent = htmlContent;
        _isLoading = false;
      });

      if (_iframe != null) {
        _iframe!.srcdoc = htmlContent;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _htmlContent = '<h3>Error loading screen: ${widget.fileName}</h3><p>$e</p>';
      });
      if (_iframe != null) {
        _iframe!.srcdoc = _htmlContent!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HtmlElementView(viewType: _viewType),
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
