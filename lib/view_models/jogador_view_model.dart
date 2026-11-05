import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/jogador_model.dart';
import '../utils/api_response.dart';

class JogadorViewModel extends ChangeNotifier {
  final String baseUrl = "http://191.252.101.12";

  List<JogadorModel> jogadores = [];
  bool carregando = false;

  Map<String, dynamic> _toMap(dynamic item) {
    if (item is Map<String, dynamic>) return item;
    if (item is Map) return item.map((k, v) => MapEntry(k.toString(), v));
    return {};
  }

  Future<void> buscarJogadores() async {
    carregando = true;
    notifyListeners();

    try {
      var response = await http.get(Uri.parse('$baseUrl/listajogadores'));
      if (response.statusCode == 200) {
        List dados = jsonDecode(response.body);
        jogadores = dados.map((j) => JogadorModel.fromJson(_toMap(j))).toList();
      }
    } catch (e) {
      debugPrint("Erro ao buscar jogadores: $e");
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarJogador(
    String nome,
    String posicao,
    int idEquipe,
  ) async {
    var mapa = {
      "nomeJogador": nome,
      "posicaoJogador": posicao,
      "idEquipeJogador": idEquipe,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/cadastrajogador'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    validarResposta(response, 'Cadastro de jogador');
    await buscarJogadores();
  }

  Future<void> atualizarJogador(
    int id,
    String nome,
    String posicao,
    int idEquipe,
  ) async {
    var mapa = {
      "idJogador": id,
      "nomeJogador": nome,
      "posicaoJogador": posicao,
      "idEquipeJogador": idEquipe,
    };
    final response = await http.put(
      Uri.parse('$baseUrl/atualizajogador'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    validarResposta(response, 'Atualização de jogador');
    await buscarJogadores();
  }

  Future<void> deletarJogador(int id) async {
    var mapa = {"idJogador": id};
    final response = await http.delete(
      Uri.parse('$baseUrl/removejogador'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    validarResposta(response, 'Remoção de jogador');
    await buscarJogadores();
  }
}
