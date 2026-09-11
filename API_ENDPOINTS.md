# API Círio de Nazaré - Documentação

**URL Base:** `https://cirio-belem-api.onrender.com/`
**Documentação interativa:** `https://cirio-belem-api.onrender.com/docs`
**Repositório:** https://gitlab.com/ricardo.casseb/cirio-belem-api

## Tecnologias da API
- Python 3 + FastAPI + Uvicorn + HTTPX
- Dados mockados/fins didáticos

---

## Endpoints Disponíveis

### Status
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/` | Status da API |

### Notícias
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/noticias` | Lista todas as notícias |
| GET | `/noticias/{id}` | Retorna uma notícia específica |

**Campos da notícia:**
```json
{
  "id": 1,
  "titulo": "string",
  "data": "YYYY-MM-DD",
  "resumo": "string",
  "imagem": "URL",
  "conteudo": "string"
}
```

### Eventos (Agenda)
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/eventos` | Lista todos os eventos |
| GET | `/eventos/{id}` | Retorna um evento específico |

**Campos do evento:**
```json
{
  "id": 1,
  "nome": "string",
  "descricao": "string",
  "data": "YYYY-MM-DD",
  "horario": "HH:MM",
  "local": "string",
  "latitude": -1.45,
  "longitude": -48.48
}
```

### Restaurantes
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/restaurantes` | Lista todos os restaurantes |
| GET | `/restaurantes/{id}` | Retorna um restaurante específico |

### Mapa / Pontos do Círio
| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/mapa/pontos` | Lista pontos importantes |
| GET | `/mapa/cirio` | Retorna o percurso completo do Círio |
| GET | `/mapa/inicio` | Local de início da procissão (Catedral) |
| GET | `/mapa/fim` | Local do final da procissão (Praça Santuário) |
| GET | `/rota/ate-inicio` | Calcula rota até o início |

**Campos do percurso:**
```json
{
  "id": 1,
  "nome": "Círio de Nazaré",
  "data": "YYYY-MM-DD",
  "distancia_km": 3.6,
  "inicio": {
    "nome": "Catedral Metropolitana de Belém",
    "latitude": -1.4561,
    "longitude": -48.50477
  },
  "fim": {
    "nome": "Praça Santuário de Nazaré",
    "latitude": -1.452601,
    "longitude": -48.481265
  },
  "pontos": [...]
}
```

---

## Exemplo de Uso no Flutter

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> carregarNoticias() async {
  final url = Uri.parse('https://cirio-belem-api.onrender.com/noticias');
  final response = await http.get(url);
  
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erro ao carregar notícias');
  }
}
```

---

## Contexto do App

O aplicativo Flutter deve consumir essa API para apresentar:
- **Notícias** sobre o Círio de Nazaré
- **Programação** (eventos/agenda)
- **Restaurantes** próximos
- **Pontos de interesse** e informações geográficas
- **Mapa** com o percurso da procissão (flutter_map)
- **Localização** e sensores do smartphone

**Evento:** Círio de Nazaré 2026 (outubro)
**Percurso:** Catedral Metropolitana → Praça Santuário de Nazaré (3.6 km)

---

## Pendente
- [ ] Aguardar push do amigo com mais endpoints/atualizações
- [ ] Implementar serviços de API no Flutter
- [ ] Criar models Dart para as entidades
- [ ] Implementar telas: Notícias, Eventos, Restaurantes, Mapa
