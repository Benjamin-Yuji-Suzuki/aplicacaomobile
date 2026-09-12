import 'dart:async';
import 'package:flutter/material.dart';

import 'noticias.dart';
import 'agenda.dart';
import 'gastronomia.dart';
import 'mapa.dart';
import 'theme/app_theme.dart';
import 'services/light_sensor_service.dart';

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

  StreamSubscription<double>? _lightSubscription;
  bool _isDarkMode = false;
  bool _sensorAvailable = false;

  @override
  void initState() {
    super.initState();
    _initLightSensor();
  }

  Future<void> _initLightSensor() async {
    _sensorAvailable = await LightSensorService.isAvailable();
    if (!_sensorAvailable) return;

    _lightSubscription = LightSensorService.events.listen(
      _updateThemeFromLight,
      onError: (_) {},
    );
  }

  void _updateThemeFromLight(double lightLevel) {
    final shouldUseDarkMode = _isDarkMode
        ? lightLevel < _lightModeThreshold
        : lightLevel < _darkModeThreshold;

    if (shouldUseDarkMode == _isDarkMode || !mounted) return;
    setState(() => _isDarkMode = shouldUseDarkMode);
  }

  @override
  void dispose() {
    _lightSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Círio de Nazaré',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
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
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.church,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 20),

            Text(
              'Círio de Nazaré',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
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
