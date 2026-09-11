import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/restaurante.dart';

class RestauranteService {
  static const String baseUrl =
      'https://cirio-belem-api.onrender.com';

  Future<List<Restaurante>> buscarRestaurantes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/restaurantes'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao carregar restaurantes: '
        '${response.statusCode}',
      );
    }

    final List<dynamic> dados =
        jsonDecode(response.body);

    return dados
        .map(
          (json) => Restaurante.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
