import 'package:flutter/material.dart';

import 'noticias.dart';
import 'agenda.dart';
import 'gastronomia.dart';
import 'mapa.dart';

void main() {
  runApp(const CirioApp());
}

class CirioApp extends StatelessWidget {
  const CirioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Círio de Nazaré',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Círio de Nazaré'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.church,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            const Text(
              'Círio de Nazaré',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 40),

            // NOTÍCIAS
            BotaoMenu(
              titulo: 'Notícias',
              icone: Icons.article,
              cor: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoticiasTela(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // AGENDA
            BotaoMenu(
              titulo: 'Agenda Cultural',
              icone: Icons.event,
              cor: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgendaTela(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // GASTRONOMIA
            BotaoMenu(
              titulo: 'Gastronomia Paraense',
              icone: Icons.restaurant,
              cor: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GastronomiaTela(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            // MAPA
            BotaoMenu(
              titulo: 'Mapa do Círio',
              icone: Icons.map,
              cor: Colors.red,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapaTela(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// BOTÃO PADRÃO
class BotaoMenu extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final VoidCallback onPressed;

  const BotaoMenu({
    super.key,
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,

      child: ElevatedButton.icon(
        onPressed: onPressed,

        icon: Icon(
          icone,
          size: 28,
        ),

        label: Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
