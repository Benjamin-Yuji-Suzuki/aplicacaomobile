import 'package:flutter/material.dart';

class GastronomiaTela extends StatelessWidget {
  const GastronomiaTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastronomia Paraense'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Text(
          'Gastronomia Paraense',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
