import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardViewModel extends ChangeNotifier {
  final String baseUrl = "http://191.252.101.12";

  int totalEquipes = 0;
  int totalJogadores = 0;
  int totalPartidas = 0;
  int golsMarcados = 0;
  bool carregando = false;

  int _parseInt(dynamic valor) {
    if (valor == null) return 0;
    if (valor is int) return valor;
    if (valor is double) return valor.toInt();
    if (valor is String) return int.tryParse(valor) ?? 0;
    return 0;
  }

  Future<void> carregarDashboard() async {
    carregando = true;
    notifyListeners();

    try {
      var resEquipes = await http.get(Uri.parse('$baseUrl/listaequipes'));
      var resJogadores = await http.get(Uri.parse('$baseUrl/listajogadores'));
      var resPartidas = await http.get(Uri.parse('$baseUrl/listapartidas'));

      if (resEquipes.statusCode == 200) {
        List eq = jsonDecode(resEquipes.body);
        totalEquipes = eq.length;
      }

      if (resJogadores.statusCode == 200) {
        List jog = jsonDecode(resJogadores.body);
        totalJogadores = jog.length;
      }

      if (resPartidas.statusCode == 200) {
        List part = jsonDecode(resPartidas.body);
        totalPartidas = part.length;
        golsMarcados = 0;
        for (var p in part) {
          final mapa = Map<String, dynamic>.from(p as Map);
          int casa = _parseInt(mapa['placarCasa'] ?? mapa['placarEquipeCasa']);
          int vis = _parseInt(mapa['placarVisitante'] ?? mapa['placarEquipeVisitante']);
          golsMarcados += (casa + vis);
        }
      }
    } catch (e) {
      print("Erro ao carregar Dashboard: $e");
    }

    carregando = false;
    notifyListeners();
  }
}