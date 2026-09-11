import 'package:flutter/material.dart';

class AgendaTela extends StatelessWidget {
  const AgendaTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Cultural'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Text(
          'Agenda Cultural do Círio',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
