import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import '../models/mapa.dart';
import '../models/rota.dart';
import '../services/api_service.dart';
import '../services/compass_service.dart';

class MapaTela extends StatefulWidget {
  const MapaTela({super.key});

  @override
  State<MapaTela> createState() => _MapaTelaState();
}

class _MapaTelaState extends State<MapaTela> {
  final MapController _mapController = MapController();
  late Future<MapaCirio> _mapaFuture;
  late Future<List<PontoInteresse>> _pontosFuture;
  LatLng? _userPosition;
  bool _loadingLocation = true;
  bool _orientationModeEnabled = false;
  bool _showingRoute = false;
  Rota? _currentRoute;
  bool _loadingRoute = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeAt;

  static const double _shakeAccelerationThreshold = 18;
  static const Duration _shakeCooldown = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _mapaFuture = ApiService.getMapaCirio();
    _pontosFuture = ApiService.getPontosInteresse();
    _getUserLocation();
    _listenForShake();
  }

  void _listenForShake() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final acceleration = math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      final now = DateTime.now();
      final canRecenter =
          _lastShakeAt == null || now.difference(_lastShakeAt!) > _shakeCooldown;

      if (acceleration >= _shakeAccelerationThreshold && canRecenter) {
        _lastShakeAt = now;
        _recenterOnUser();
      }
    });
  }

  Future<void> _recenterOnUser() async {
    final knownPosition = _userPosition;
    if (knownPosition != null) {
      _mapController.move(knownPosition, 16);
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      final userPosition = LatLng(position.latitude, position.longitude);
      setState(() => _userPosition = userPosition);
      _mapController.move(userPosition, 16);
    } catch (_) {}
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _loadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _loadingLocation = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _userPosition = LatLng(position.latitude, position.longitude);
        _loadingLocation = false;
      });
    } catch (e) {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _loadRouteToStart() async {
    if (_userPosition == null) return;

    setState(() => _loadingRoute = true);

    try {
      final route = await ApiService.getRetaAteInicio(
        _userPosition!.latitude,
        _userPosition!.longitude,
      );
      setState(() {
        _currentRoute = route;
        _showingRoute = true;
        _loadingRoute = false;
      });
    } catch (e) {
      setState(() => _loadingRoute = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar rota: $e')),
        );
      }
    }
  }

  void _toggleRoute() {
    if (_showingRoute) {
      setState(() {
        _showingRoute = false;
        _currentRoute = null;
      });
    } else {
      _loadRouteToStart();
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa do Círio'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<MapaCirio>(
        future: _mapaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _mapaFuture = ApiService.getMapaCirio();
                      });
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final mapa = snapshot.data!;
          final pontos = mapa.pontos
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(mapa.inicio.latitude, mapa.inicio.longitude),
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.cirio',
                  ),

                  // Linha do percurso oficial do Círio
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: pontos,
                        strokeWidth: 4,
                        color: Colors.red,
                      ),
                    ],
                  ),

                  // Linha da rota até o início (se ativa)
                  if (_showingRoute && _currentRoute != null)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _currentRoute!.pontos,
                          strokeWidth: 5,
                          color: Colors.blue,
                          borderStrokeWidth: 2,
                          borderColor: Colors.white,
                        ),
                      ],
                    ),

                  // Marcadores
                  MarkerLayer(
                    markers: [
                      // Início
                      Marker(
                        point: LatLng(mapa.inicio.latitude, mapa.inicio.longitude),
                        width: 80,
                        height: 80,
                        child: const Column(
                          children: [
                            Icon(Icons.play_circle, color: Colors.green, size: 40),
                          ],
                        ),
                      ),

                      // Fim
                      Marker(
                        point: LatLng(mapa.fim.latitude, mapa.fim.longitude),
                        width: 80,
                        height: 80,
                        child: const Column(
                          children: [
                            Icon(Icons.flag, color: Colors.red, size: 40),
                          ],
                        ),
                      ),

                      // Posição do usuário
                      if (_userPosition != null)
                        Marker(
                          point: _userPosition!,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                    ],
                  ),

                  // Pontos de interesse
                  FutureBuilder<List<PontoInteresse>>(
                    future: _pontosFuture,
                    builder: (context, pontosSnapshot) {
                      if (!pontosSnapshot.hasData) return const SizedBox.shrink();

                      return MarkerLayer(
                        markers: pontosSnapshot.data!.map((ponto) {
                          IconData icon;
                          Color color;
                          switch (ponto.tipo) {
                            case 'inicio':
                              icon = Icons.play_circle;
                              color = Colors.green;
                              break;
                            case 'chegada':
                              icon = Icons.flag;
                              color = Colors.red;
                              break;
                            case 'ponto_turistico':
                              icon = Icons.camera_alt;
                              color = Colors.orange;
                              break;
                            default:
                              icon = Icons.place;
                              color = Colors.purple;
                          }

                          return Marker(
                            point: LatLng(ponto.latitude, ponto.longitude),
                            width: 80,
                            height: 80,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(ponto.nome),
                                    content: Text(ponto.descricao),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Fechar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(icon, color: color, size: 35),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),

              // Overlay de orientação
              if (_orientationModeEnabled)
                _OrientationOverlay(
                  userPosition: _userPosition,
                  destination: LatLng(mapa.inicio.latitude, mapa.inicio.longitude),
                ),

              // Card com informações da rota
              if (_showingRoute && _currentRoute != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions, color: Colors.blue),
                              const SizedBox(width: 8),
                              const Text(
                                'Como chegar ao Círio',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Distância: ${(_currentRoute!.distanciaMetros / 1000).toStringAsFixed(1)} km',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Tempo estimado: ${(_currentRoute!.duracaoSegundos / 60).toStringAsFixed(0)} min',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 4,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Sua rota'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 4,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Percurso oficial'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Indicador de carregando rota
              if (_loadingRoute)
                const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text('Calculando rota...'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_userPosition != null)
            FloatingActionButton(
              heroTag: 'user',
              onPressed: () {
                _mapController.move(_userPosition!, 16);
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          const SizedBox(height: 10),
          // FAB Como chegar
          if (_userPosition != null)
            FloatingActionButton(
              heroTag: 'route_to_start',
              onPressed: _loadingRoute ? null : _toggleRoute,
              backgroundColor: _showingRoute ? Colors.blue : Colors.teal,
              child: _loadingRoute
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.directions, color: Colors.white),
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'orientation',
            onPressed: () {
              setState(() {
                _orientationModeEnabled = !_orientationModeEnabled;
              });
            },
            backgroundColor:
                _orientationModeEnabled ? Colors.green : Colors.indigo,
            child: const Icon(Icons.navigation, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'route',
            onPressed: () {
              _mapaFuture.then((mapa) {
                _mapController.move(
                  LatLng(mapa.inicio.latitude, mapa.inicio.longitude),
                  14,
                );
              });
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.route, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _OrientationOverlay extends StatelessWidget {
  const _OrientationOverlay({
    required this.userPosition,
    required this.destination,
  });

  final LatLng? userPosition;
  final LatLng destination;

  double _bearingToDestination() {
    final origin = userPosition!;
    final latitude1 = origin.latitude * math.pi / 180;
    final latitude2 = destination.latitude * math.pi / 180;
    final differenceLongitude =
        (destination.longitude - origin.longitude) * math.pi / 180;
    final bearing = math.atan2(
      math.sin(differenceLongitude) * math.cos(latitude2),
      math.cos(latitude1) * math.sin(latitude2) -
          math.sin(latitude1) *
              math.cos(latitude2) *
              math.cos(differenceLongitude),
    );

    return (bearing + 2 * math.pi) % (2 * math.pi);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: userPosition == null
              ? const Row(
                  children: [
                    Icon(Icons.location_searching, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(child: Text('Obtendo sua localização...')),
                  ],
                )
              : StreamBuilder<double>(
                  stream: CompassService.events,
                  builder: (context, snapshot) {
                    final heading = snapshot.data;
                    if (heading == null) {
                      return const Row(
                        children: [
                          Icon(Icons.explore_off, color: Colors.orange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'A orientação do aparelho não está disponível.',
                            ),
                          ),
                        ],
                      );
                    }

                    final angle =
                        _bearingToDestination() - heading * math.pi / 180;
                    return Row(
                      children: [
                        Transform.rotate(
                          angle: angle,
                          child: const Icon(
                            Icons.navigation,
                            color: Colors.red,
                            size: 44,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Siga a seta para o início da procissão',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
