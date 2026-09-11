import 'package:flutter/material.dart';

class MapaTela extends StatelessWidget {
  const MapaTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa do Círio'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Text(
          'Mapa do Círio',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
