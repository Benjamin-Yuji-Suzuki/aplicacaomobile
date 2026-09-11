import 'package:flutter/material.dart';

import 'models/evento.dart';
import 'services/evento_service.dart';

class AgendaTela extends StatefulWidget {
  const AgendaTela({super.key});

  @override
  State<AgendaTela> createState() => _AgendaTelaState();
}

class _AgendaTelaState extends State<AgendaTela> {
  final EventoService service = EventoService();

  late Future<List<Evento>> futureEventos;

  @override
  void initState() {
    super.initState();

    futureEventos = service.buscarEventos();
  }

  Future<void> atualizarEventos() async {
    setState(() {
      futureEventos = service.buscarEventos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Cultural'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await atualizarEventos();
        },

        child: FutureBuilder<List<Evento>>(
          future: futureEventos,

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
                        Icons.cloud_off,
                        size: 60,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Não foi possível carregar a programação.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: atualizarEventos,

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

            // ==============================
            // DADOS
            // ==============================

            final eventos = snapshot.data ?? [];

            // ==============================
            // LISTA VAZIA
            // ==============================

            if (eventos.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum evento disponível.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            }

            // ==============================
            // LISTA DE EVENTOS
            // ==============================

            return ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.all(16),

              itemCount: eventos.length,

              itemBuilder: (context, index) {
                final evento = eventos[index];

                return _CardEvento(
                  evento: evento,
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class _CardEvento extends StatelessWidget {
  final Evento evento;

  const _CardEvento({
    required this.evento,
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

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==============================
            // NOME
            // ==============================

            Text(
              evento.nome,

              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 12),

            // ==============================
            // DATA
            // ==============================

            _InformacaoEvento(
              icone: Icons.calendar_today,
              texto: evento.data,
            ),

            const SizedBox(height: 8),

            // ==============================
            // HORÁRIO
            // ==============================

            _InformacaoEvento(
              icone: Icons.access_time,
              texto: evento.horario,
            ),

            const SizedBox(height: 8),

            // ==============================
            // LOCAL
            // ==============================

            _InformacaoEvento(
              icone: Icons.location_on,
              texto: evento.local,
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 12),

            // ==============================
            // DESCRIÇÃO
            // ==============================

            Text(
              evento.descricao,

              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _InformacaoEvento extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _InformacaoEvento({
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
          size: 20,
          color: Colors.orange,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            texto,

            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
