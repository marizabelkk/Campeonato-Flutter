import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/partida_model.dart';
import '../utils/api_response.dart';

class PartidaViewModel extends ChangeNotifier {
  final String baseUrl = 'http://191.252.101.12';

  List<PartidaModel> partidas = [];
  bool carregando = false;

  Map<String, dynamic> _toMap(dynamic item) {
    if (item is Map<String, dynamic>) return item;
    if (item is Map) {
      return item.map((key, value) => MapEntry(key.toString(), value));
    }
    return {};
  }

  List<dynamic> _extrairPartidas(dynamic resposta) {
    if (resposta is! List) {
      return [];
    }
    if (resposta.isNotEmpty && resposta.first is List) {
      return _extrairPartidas(resposta.first);
    }
    return resposta.whereType<Map>().toList();
  }

  Future<void> buscarPartidas() async {
    carregando = true;
    notifyListeners();

    try {
      // A rota simples traz em campos separados o ID da partida, os gols e os
      // IDs das equipes. A tela resolve os nomes das equipes separadamente.
      final response = await http.get(Uri.parse('$baseUrl/listapartidas'));
      if (response.statusCode != 200) {
        throw Exception('Falha ao listar partidas (${response.statusCode}).');
      }
      final dados = _extrairPartidas(jsonDecode(response.body));
      partidas = dados
          .map((item) => PartidaModel.fromJson(_toMap(item)))
          .toList();
    } catch (erro) {
      debugPrint('Erro ao buscar partidas: $erro');
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarPartida(
    String data,
    int golsCasa,
    int golsVisitante,
    int idEquipeCasa,
    int idEquipeVisitante,
  ) async {
    final dados = {
      'dataPartida': data,
      'placarEquipeCasa': golsCasa,
      'placarEquipeVisitante': golsVisitante,
      'idEquipeCasa': idEquipeCasa,
      'idEquipeVisitante': idEquipeVisitante,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/cadastrapartida'),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode(dados),
      encoding: Encoding.getByName('utf-8'),
    );
    validarResposta(response, 'Cadastro de partida');
    await buscarPartidas();
  }

  Future<void> atualizarPartida(
    int idPartida,
    String data,
    int golsCasa,
    int golsVisitante,
    int idEquipeCasa,
    int idEquipeVisitante,
  ) async {
    final dados = {
      'idPartida': idPartida,
      'dataPartida': data,
      'placarEquipeCasa': golsCasa,
      'placarEquipeVisitante': golsVisitante,
      'idEquipeCasa': idEquipeCasa,
      'idEquipeVisitante': idEquipeVisitante,
    };
    final response = await http.put(
      Uri.parse('$baseUrl/atualizapartida'),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode(dados),
      encoding: Encoding.getByName('utf-8'),
    );
    validarResposta(response, 'Atualização de partida');
    await buscarPartidas();
  }

  Future<void> deletarPartida(int idPartida) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/removepartida'),
      headers: {
        'Accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode({'idPartida': idPartida}),
      encoding: Encoding.getByName('utf-8'),
    );
    validarResposta(response, 'Remoção de partida');
    await buscarPartidas();
  }
}
