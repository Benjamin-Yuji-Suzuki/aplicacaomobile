import 'package:flutter/material.dart';

class NoticiasTela extends StatelessWidget {
  const NoticiasTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícias'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Text(
          'Notícias do Círio',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
