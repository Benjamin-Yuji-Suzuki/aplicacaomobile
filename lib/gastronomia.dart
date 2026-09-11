import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'models/restaurante.dart';
import 'services/restaurante_service.dart';

class GastronomiaTela extends StatefulWidget {
  const GastronomiaTela({super.key});

  @override
  State<GastronomiaTela> createState() =>
      _GastronomiaTelaState();
}

class _GastronomiaTelaState
    extends State<GastronomiaTela> {

  final RestauranteService service =
      RestauranteService();

  late Future<List<Restaurante>>
      futureRestaurantes;

  @override
  void initState() {
    super.initState();

    futureRestaurantes =
        service.buscarRestaurantes();
  }

  Future<void> atualizarRestaurantes() async {
    setState(() {
      futureRestaurantes =
          service.buscarRestaurantes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gastronomia Paraense',
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await atualizarRestaurantes();
        },

        child: FutureBuilder<List<Restaurante>>(
          future: futureRestaurantes,

          builder: (context, snapshot) {

            // ==============================
            // CARREGANDO
            // ==============================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ==============================
            // ERRO
            // ==============================

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Icon(
                        Icons.restaurant,
                        size: 60,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Não foi possível carregar os restaurantes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed:
                            atualizarRestaurantes,

                        icon: const Icon(
                          Icons.refresh,
                        ),

                        label: const Text(
                          'Tentar novamente',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final restaurantes =
                snapshot.data ?? [];

            // ==============================
            // LISTA VAZIA
            // ==============================

            if (restaurantes.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum restaurante disponível.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            }

            // ==============================
            // RESTAURANTES
            // ==============================

            return ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.all(16),

              itemCount: restaurantes.length,

              itemBuilder: (context, index) {

                final restaurante =
                    restaurantes[index];

                return _CardRestaurante(
                  restaurante: restaurante,
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class _CardRestaurante extends StatelessWidget {

  final Restaurante restaurante;

  const _CardRestaurante({
    required this.restaurante,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),

      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: () {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
                  RestauranteDetalhesTela(
                restaurante: restaurante,
              ),
            ),
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // NOME
              Text(
                restaurante.nome,

                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 12),

              // ENDEREÇO
              _InformacaoRestaurante(
                icone: Icons.location_on,
                texto: restaurante.endereco,
              ),

              const SizedBox(height: 10),

              // ESPECIALIDADES
              const Text(
                'Especialidades',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 6),

              Wrap(
                spacing: 6,
                runSpacing: 6,

                children: restaurante.especialidades
                    .map(
                      (especialidade) =>
                          Chip(
                        label: Text(
                          especialidade,
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 12),

              // DESCRIÇÃO
              Text(
                restaurante.descricao,

                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              // HORÁRIO
              if (restaurante.horario != null &&
                  restaurante.horario!.isNotEmpty) ...[
                const SizedBox(height: 12),

                _InformacaoRestaurante(
                  icone: Icons.access_time,
                  texto: restaurante.horario!,
                ),
              ],

              const SizedBox(height: 14),

              // MAPA
              const Align(
                alignment: Alignment.centerRight,

                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    Text(
                      'Ver no mapa',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 5),

                    Icon(
                      Icons.map,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _InformacaoRestaurante
    extends StatelessWidget {

  final IconData icone;
  final String texto;

  const _InformacaoRestaurante({
    required this.icone,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Icon(
          icone,
          color: Colors.green,
          size: 20,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            texto,

            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}



class RestauranteDetalhesTela
    extends StatelessWidget {

  final Restaurante restaurante;

  const RestauranteDetalhesTela({
    super.key,
    required this.restaurante,
  });

  @override
  Widget build(BuildContext context) {

    final posicao = LatLng(
      restaurante.latitude,
      restaurante.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurante.nome,
        ),

        backgroundColor: Colors.green,

        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [

          // =========================================
          // MAPA
          // =========================================

          SizedBox(
            height: 320,

            child: FlutterMap(
              options: MapOptions(
                initialCenter: posicao,

                initialZoom: 16,
              ),

              children: [

                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                  userAgentPackageName:
                      'com.example.cirio',
                ),

                MarkerLayer(
                  markers: [

                    Marker(
                      point: posicao,

                      width: 60,
                      height: 60,

                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =========================================
          // INFORMAÇÕES
          // =========================================

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // NOME
                  Text(
                    restaurante.nome,

                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ENDEREÇO
                  _InformacaoRestaurante(
                    icone: Icons.location_on,
                    texto: restaurante.endereco,
                  ),

                  const SizedBox(height: 14),

                  // HORÁRIO
                  if (restaurante.horario != null &&
                      restaurante.horario!.isNotEmpty)
                    _InformacaoRestaurante(
                      icone: Icons.access_time,
                      texto: restaurante.horario!,
                    ),

                  const SizedBox(height: 20),

                  const Text(
                    'Especialidades',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children:
                        restaurante.especialidades
                            .map(
                              (item) => Chip(
                                label: Text(item),
                              ),
                            )
                            .toList(),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Descrição',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    restaurante.descricao,

                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Coordenadas',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${restaurante.latitude}, '
                    '${restaurante.longitude}',

                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
