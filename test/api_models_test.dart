import 'package:flutter_test/flutter_test.dart';
import 'package:campeonato/models/equipe_model.dart';
import 'package:campeonato/models/jogador_model.dart';
import 'package:campeonato/models/partida_model.dart';

void main() {
  test('partida mantém os gols separados dos IDs das equipes', () {
    final partida = PartidaModel.fromJson({
      'id_partida': 12,
      'dataPartida': '2026-05-20',
      'placarCasa': 3,
      'placarVisitante': 2,
      'equipeCasa': 18,
      'equipeVisitante': 23,
    });

    expect(partida.idPartida, 12);
    expect(partida.idEquipeCasa, 18);
    expect(partida.idEquipeVisitante, 23);
    expect(partida.placarEquipeCasa, 3);
    expect(partida.placarEquipeVisitante, 2);
  });

  test('modelos aceitam IDs snake_case retornados pela API', () {
    final equipe = EquipeModel.fromJson({
      'id_equipe': 18,
      'nome': 'Equipe exemplo',
      'cidade': 'Recife',
    });
    final jogador = JogadorModel.fromJson({
      'id_jogador': 7,
      'id_equipe_fk': 18,
      'nome': 'Jogador exemplo',
      'posicao': 'Atacante',
    });

    expect(equipe.idEquipe, 18);
    expect(jogador.idJogador, 7);
    expect(jogador.idEquipeJogador, 18);
  });
}
