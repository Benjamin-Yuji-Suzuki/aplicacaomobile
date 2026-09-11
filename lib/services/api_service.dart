import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';
import '../models/mapa.dart';

class ApiService {
  static const String baseUrl = 'https://cirio-belem-api.onrender.com';

  static Future<List<Noticia>> getNoticias() async {
    final url = Uri.parse('$baseUrl/noticias');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar notícias: ${response.statusCode}');
    }
  }

  static Future<Noticia> getNoticia(int id) async {
    final url = Uri.parse('$baseUrl/noticias/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Noticia.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Notícia não encontrada');
    }
  }

  static Future<MapaCirio> getMapaCirio() async {
    final url = Uri.parse('$baseUrl/mapa/cirio');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return MapaCirio.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao carregar mapa: ${response.statusCode}');
    }
  }

  static Future<List<PontoInteresse>> getPontosInteresse() async {
    final url = Uri.parse('$baseUrl/mapa/pontos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((json) => PontoInteresse.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar pontos: ${response.statusCode}');
    }
  }
}
