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

  Map<String, dynamic> _toMap(dynamic item) {
    if (item is Map<String, dynamic>) return item;
    if (item is Map) return item.map((k, v) => MapEntry(k.toString(), v));
    // Flutter Web: objeto JS — converte via jsonDecode(jsonEncode(...))
    try {
      return Map<String, dynamic>.from(item as Map);
    } catch (_) {
      return {};
    }
  }

  List<Map<String, dynamic>> _extrairRegistros(dynamic resposta) {
    if (resposta is! List) return [];
    if (resposta.isNotEmpty && resposta.first is List) {
      return _extrairRegistros(resposta.first);
    }
    return resposta.whereType<Map>().map(_toMap).toList();
  }

  Future<void> carregarDashboard() async {
    carregando = true;
    notifyListeners();

    try {
      var resEquipes = await http.get(Uri.parse('$baseUrl/listaequipes'));
      var resJogadores = await http.get(Uri.parse('$baseUrl/listajogadores'));
      var resPartidas = await http.get(Uri.parse('$baseUrl/listapartidas'));

      if (resEquipes.statusCode == 200) {
        final eq = _extrairRegistros(jsonDecode(resEquipes.body));
        totalEquipes = eq.length;
      }

      if (resJogadores.statusCode == 200) {
        final jog = _extrairRegistros(jsonDecode(resJogadores.body));
        totalJogadores = jog.length;
      }

      if (resPartidas.statusCode == 200) {
        final part = _extrairRegistros(jsonDecode(resPartidas.body));
        totalPartidas = part.length;
        golsMarcados = 0;
        for (var p in part) {
          final mapa = p;
          int casa = _parseInt(mapa['placarCasa'] ?? mapa['placarEquipeCasa']);
          int vis = _parseInt(
            mapa['placarVisitante'] ?? mapa['placarEquipeVisitante'],
          );
          golsMarcados += (casa + vis);
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar Dashboard: $e");
    }

    carregando = false;
    notifyListeners();
  }
}
