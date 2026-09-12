import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ambient_light/ambient_light.dart';

import 'noticias.dart';
import 'agenda.dart';
import 'gastronomia.dart';
import 'mapa.dart';

void main() {
  runApp(const CirioApp());
}

class CirioApp extends StatefulWidget {
  const CirioApp({super.key});

  @override
  State<CirioApp> createState() => _CirioAppState();
}

class _CirioAppState extends State<CirioApp> {
  static const double _darkModeThreshold = 20;
  static const double _lightModeThreshold = 40;

  final AmbientLight _ambientLight = AmbientLight();
  StreamSubscription<double>? _ambientLightSubscription;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _readAmbientLight();
    _ambientLightSubscription = _ambientLight.ambientLightStream.listen(
      _updateThemeFromAmbientLight,
      onError: (_) {},
    );
  }

  Future<void> _readAmbientLight() async {
    try {
      final lightLevel = await _ambientLight.currentAmbientLight();
      if (lightLevel != null) {
        _updateThemeFromAmbientLight(lightLevel);
      }
    } catch (_) {}
  }

  void _updateThemeFromAmbientLight(double lightLevel) {
    final shouldUseDarkMode = _isDarkMode
        ? lightLevel < _lightModeThreshold
        : lightLevel < _darkModeThreshold;

    if (shouldUseDarkMode == _isDarkMode || !mounted) return;
    setState(() => _isDarkMode = shouldUseDarkMode);
  }

  @override
  void dispose() {
    _ambientLightSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Círio de Nazaré',
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
