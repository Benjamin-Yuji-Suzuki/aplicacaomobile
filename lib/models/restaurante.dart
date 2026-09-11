class Restaurante {
  final int id;
  final String nome;
  final String endereco;
  final List<String> especialidades;
  final String descricao;
  final String? horario;
  final double latitude;
  final double longitude;

  Restaurante({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.especialidades,
    required this.descricao,
    required this.horario,
    required this.latitude,
    required this.longitude,
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) {
    return Restaurante(
      id: (json['id'] as num).toInt(),

      nome: json['nome'] as String,

      endereco: json['endereco'] as String,

      especialidades:
          (json['especialidades'] as List<dynamic>)
              .map((item) => item.toString())
              .toList(),

      descricao: json['descricao'] as String,

      // A API atual ainda não envia este campo.
      horario: json['horario']?.toString(),

      latitude:
          (json['latitude'] as num).toDouble(),

      longitude:
          (json['longitude'] as num).toDouble(),
    );
  }
}
