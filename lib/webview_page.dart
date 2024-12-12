import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndInitialize();
  }

  Future<void> _requestPermissionsAndInitialize() async {
    try {
      if (!kIsWeb) {
        // Request camera permission explicitly
        final cameraStatus = await Permission.camera.request();
        if (cameraStatus.isDenied) {
          // Show dialog if permission is denied
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Camera Permission Required'),
                content: const Text('Camera permission is required for AR navigation. Please enable it in settings.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      openAppSettings();
                    },
                    child: const Text('Open Settings'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            );
          }
          return;
        }
      }
      await _initializeWebView();
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  Future<void> _initializeWebView() async {
    try {
      // Create platform-specific controller
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

      // Configure controller
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setBackgroundColor(Colors.white);

      // Enable camera access for Android
      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        final AndroidWebViewController androidController = controller.platform as AndroidWebViewController;
        await androidController.setMediaPlaybackRequiresUserGesture(false);
        
        // Set permissions for Android WebView
        await androidController.setOnShowFileSelector((FileSelectorParams params) async {
          return [];
        });
      }

      // Set navigation delegate
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) async {
            if (mounted) {
              // Inject JavaScript to request camera access
              await controller.runJavaScript('''
                navigator.mediaDevices.getUserMedia({ 
                  video: { 
                    facingMode: 'environment'
                  }, 
                  audio: false 
                })
                .then(function(stream) {
                  console.log('Camera access granted');
                })
                .catch(function(err) {
                  console.error('Camera access error:', err);
                });
              ''');
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      );

      // Add JavaScript channel for communication
      await controller.addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          print('Message from website: ${message.message}');
        },
      );

      // Enable DOM storage
      await controller.enableZoom(false);

      // Load the URL
      await controller.loadRequest(Uri.parse(widget.url));

      // Update controller if widget is still mounted
      if (mounted) {
        setState(() {
          _controller = controller;
        });
      }
    } catch (e) {
      print('Error initializing WebView: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller != null) {
          if (await _controller!.canGoBack()) {
            await _controller!.goBack();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            if (_controller != null)
              WebViewWidget(controller: _controller!)
            else
              const Center(
                child: Text('Loading WebView...'),
              ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
