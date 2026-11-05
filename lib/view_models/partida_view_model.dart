import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/partida_model.dart';

class PartidaViewModel extends ChangeNotifier {
  final String baseUrl = "http://191.252.101.12"; // Substitua pelo IP do seu servidor

  List<PartidaModel> partidas = [];
  bool carregando = false;

  Future<void> buscarPartidasDetalhadas() async {
    carregando = true;
    notifyListeners();

    try {
      var response = await http.get(Uri.parse('$baseUrl/listapartidasdetalhada'));
      
      if (response.statusCode == 200) {
        List dados = jsonDecode(response.body);
        if (dados.isNotEmpty) {
          partidas = dados.map((item) {
            final mapa = Map<String, dynamic>.from(item as Map);
            return PartidaModel.fromJson(mapa);
          }).toList();
        } else {
          await _buscarPartidasSimples();
        }
      } else {
        await _buscarPartidasSimples();
      }
    } catch (e) {
      print("Erro ao buscar partidas detalhadas: $e");
      await _buscarPartidasSimples();
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> _buscarPartidasSimples() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/listapartidas'));
      if (response.statusCode == 200) {
        List dados = jsonDecode(response.body);
        partidas = dados.map((item) {
          final mapa = Map<String, dynamic>.from(item as Map);
          return PartidaModel.fromJson(mapa);
        }).toList();
      }
    } catch (e) {
      print("Erro ao buscar partidas simples: $e");
    }
  }

  Future<void> cadastrarPartida(
    String data, int placarCasa, int placarVisitante, int idCasa, int idVisitante) async {
    var mapa = {
      "dataPartida": data,
      "placarEquipeCasa": placarCasa,
      "placarEquipeVisitante": placarVisitante,
      "idEquipeCasa": idCasa,
      "idEquipeVisitante": idVisitante
    };
    await http.post(
      Uri.parse('$baseUrl/cadastrapartida'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    await buscarPartidasDetalhadas();
  }

  Future<void> atualizarPartida(
    int id, String data, int placarCasa, int placarVisitante, int idCasa, int idVisitante) async {
    var mapa = {
      "idPartida": id,
      "dataPartida": data,
      "placarEquipeCasa": placarCasa,
      "placarEquipeVisitante": placarVisitante,
      "idEquipeCasa": idCasa,
      "idEquipeVisitante": idVisitante
    };
    await http.put(
      Uri.parse('$baseUrl/atualizapartida'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    await buscarPartidasDetalhadas();
  }

  Future<void> deletarPartida(int id) async {
    var mapa = {"idPartida": id};
    await http.delete(
      Uri.parse('$baseUrl/removepartida'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(mapa),
      encoding: Encoding.getByName("utf-8"),
    );
    await buscarPartidasDetalhadas();
  }
}