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
