import 'package:latlong2/latlong.dart';
import 'local.dart';

class Rota {
  final LatLng origem;
  final Local destino;
  final double distanciaMetros;
  final double duracaoSegundos;
  final List<LatLng> pontos;

  Rota({
    required this.origem,
    required this.destino,
    required this.distanciaMetros,
    required this.duracaoSegundos,
    required this.pontos,
  });

  factory Rota.fromJson(Map<String, dynamic> json) {
    return Rota(
      origem: LatLng(
        (json['origem']['latitude'] as num).toDouble(),
        (json['origem']['longitude'] as num).toDouble(),
      ),
      destino: Local.fromJson(json['destino']),
      distanciaMetros: (json['distancia_metros'] as num).toDouble(),
      duracaoSegundos: (json['duracao_segundos'] as num).toDouble(),
      pontos: (json['pontos'] as List)
          .map((p) => LatLng(
                (p['latitude'] as num).toDouble(),
                (p['longitude'] as num).toDouble(),
              ))
          .toList(),
    );
  }
}
