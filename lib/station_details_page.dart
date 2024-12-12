import 'package:flutter/material.dart';
import 'package:railway_navigation_app/welcome_page.dart';
import 'package:railway_navigation_app/webview_page.dart';

class StationDetailsPage extends StatelessWidget {
  final String stationName;

  const StationDetailsPage({
    super.key,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stationName),
        backgroundColor: const Color.fromARGB(255, 70, 3, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              stationName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 20, 199),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 70, 3, 255),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // Add navigation logic here
              },
              child: Text(
                LocalizationService.translate('start_navigation'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CourierPrime',
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildNavigationTile(
              icon: Icons.camera,
              title: LocalizationService.translate('ar_view'),
              color: const Color(0xFFFF5722),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                      url: 'https://ar-navigation-kappa.vercel.app/',
                      title: LocalizationService.translate('ar_view'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: color),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 70, 3, 255),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onTap,
    );
  }
}