import 'package:flutter/material.dart';
import 'dart:async'; // For Timer functionality
import 'navigation_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'map_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize WebView platform based on platform
  if (!kIsWeb) {
    if (WebViewPlatform.instance == null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        WebViewPlatform.instance = AndroidWebViewPlatform();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        WebViewPlatform.instance = WebKitWebViewPlatform();
      }
    }
    
    // Request camera permission
    final status = await Permission.camera.request();
    if (status.isDenied) {
      print('Camera permission was denied');
    }
  }
  
  await dotenv.load(fileName: "assets/.env");
  runApp(const RailwayNavigationApp());
}

Future<void> loadEnvFile() async {
  if (kIsWeb) {
    await dotenv.load(fileName: "assets/.env");
  } else {
    await dotenv.load(fileName: ".env");
  }
}

class RailwayNavigationApp extends StatelessWidget {
  const RailwayNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugShowCheckedModeBanner: true;
    return MaterialApp(
      title: 'Railway Navigation',
      theme: ThemeData(
        brightness: Brightness.dark,
        cardColor: const Color.fromARGB(255, 70, 3, 255),
        fontFamily: 'CourierPrime',
      ),
      home: const SplashScreen(), // Set SplashScreen as the home
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NavigationMainPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Center(
        // Single centered logo with animation
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/logo.png',
            width: 300,
            height: 300,
          ),
        ),
      ),
    ),
  );
}
    }