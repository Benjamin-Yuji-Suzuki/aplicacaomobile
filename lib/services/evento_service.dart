import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/evento.dart';

class EventoService {
  static const String baseUrl =
      'https://cirio-belem-api.onrender.com';

  Future<List<Evento>> buscarEventos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/eventos'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao carregar eventos: ${response.statusCode}',
      );
    }

    final List<dynamic> dados =
        jsonDecode(response.body);

    return dados
        .map(
          (json) => Evento.fromJson(json),
        )
        .toList();
  }
}
