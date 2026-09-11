class Noticia {
  final int id;
  final String titulo;
  final String data;
  final String resumo;
  final String imagem;
  final String conteudo;

  Noticia({
    required this.id,
    required this.titulo,
    required this.data,
    required this.resumo,
    required this.imagem,
    required this.conteudo,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      data: json['data'] ?? '',
      resumo: json['resumo'] ?? '',
      imagem: json['imagem'] ?? '',
      conteudo: json['conteudo'] ?? '',
    );
  }
}
