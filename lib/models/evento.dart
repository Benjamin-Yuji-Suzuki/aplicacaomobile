class Evento {
  final int id;
  final String nome;
  final String descricao;
  final String data;
  final String horario;
  final String local;
  final double latitude;
  final double longitude;

  Evento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.local,
    required this.latitude,
    required this.longitude,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      data: json['data'],
      horario: json['horario'],
      local: json['local'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
