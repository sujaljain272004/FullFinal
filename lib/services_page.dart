import 'package:flutter/material.dart';
import 'pnr_status_page.dart';
import 'train_search_page.dart';
import 'train_status_page.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  Widget _buildServiceButton(BuildContext context, String labelKey, IconData icon, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F3FF),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: const Color(0xFF4B5EFC), size: 30),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          labelKey,
          style: const TextStyle(
            color: Color(0xFF4B5EFC),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: const Color(0xFF4B5EFC),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildServiceButton(
                context,
                'PNR',
                Icons.confirmation_number_outlined,
                () {
                  // Navigate to PNR Status Page
                },
              ),
              _buildServiceButton(
                context,
                'Location',
                Icons.location_on_outlined,
                () {
                  // Navigate to Train Status Page
                },
              ),
              _buildServiceButton(
                context,
                'Name',
                Icons.train_outlined,
                () {
                  // Navigate to Train Search Page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 