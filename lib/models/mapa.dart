class MapaCirio {
  final int id;
  final String nome;
  final String data;
  final double distanciaKm;
  final Local inicio;
  final Local fim;
  final List<Local> pontos;

  MapaCirio({
    required this.id,
    required this.nome,
    required this.data,
    required this.distanciaKm,
    required this.inicio,
    required this.fim,
    required this.pontos,
  });

  factory MapaCirio.fromJson(Map<String, dynamic> json) {
    return MapaCirio(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      data: json['data'] ?? '',
      distanciaKm: (json['distancia_km'] ?? 0).toDouble(),
      inicio: Local.fromJson(json['inicio']),
      fim: Local.fromJson(json['fim']),
      pontos: (json['pontos'] as List)
          .map((p) => Local.fromJson(p))
          .toList(),
    );
  }
}

class Local {
  final String nome;
  final double latitude;
  final double longitude;

  Local({
    required this.nome,
    required this.latitude,
    required this.longitude,
  });

  factory Local.fromJson(Map<String, dynamic> json) {
    return Local(
      nome: json['nome'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}

class PontoInteresse {
  final int id;
  final String nome;
  final String tipo;
  final String descricao;
  final double latitude;
  final double longitude;

  PontoInteresse({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.descricao,
    required this.latitude,
    required this.longitude,
  });

  factory PontoInteresse.fromJson(Map<String, dynamic> json) {
    return PontoInteresse(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? '',
      descricao: json['descricao'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
