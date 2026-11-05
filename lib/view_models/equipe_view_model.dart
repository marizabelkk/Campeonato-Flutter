import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/equipe_model.dart';

class EquipeViewModel extends ChangeNotifier {
  final String baseUrl = "http://191.252.101.12"; // Altere para o IP do seu servidor

  List<EquipeModel> equipes = [];
  bool carregando = false;

  Future<void> buscarEquipes() async {
    carregando = true;
    notifyListeners();

    try {
      var response = await http.get(Uri.parse('$baseUrl/listaequipes'));
      if (response.statusCode == 200) {
        List dados = jsonDecode(response.body);
        equipes = dados.map((e) => EquipeModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Erro ao buscar equipes: $e");
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarEquipe(String nome, String cidade) async {
    var mapa = {"nomeEquipe": nome, "cidadeEquipe": cidade};
    await http.post(
      Uri.parse('$baseUrl/cadastraequipe'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    await buscarEquipes();
  }

  Future<void> atualizarEquipe(int id, String nome, String cidade) async {
    var mapa = {"idEquipe": id, "nomeEquipe": nome, "cidadeEquipe": cidade};
    await http.put(
      Uri.parse('$baseUrl/atualizaequipe'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    await buscarEquipes();
  }

  Future<void> deletarEquipe(int id) async {
    var mapa = {"idEquipe": id};
    await http.delete(
      Uri.parse('$baseUrl/removeequipe'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    await buscarEquipes();
  }
}