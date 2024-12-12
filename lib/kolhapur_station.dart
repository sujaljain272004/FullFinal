import 'package:flutter/material.dart';

class KolhapurStation extends StatelessWidget {
  const KolhapurStation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B5EFC),
        title: const Text(
          'Kolhapur Station',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Kolhapur Station Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}