class JogadorModel {
  int? idJogador;
  String nomeJogador;
  String posicaoJogador;
  int idEquipeJogador;

  JogadorModel({
    this.idJogador,
    required this.nomeJogador,
    required this.posicaoJogador,
    required this.idEquipeJogador,
  });

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  factory JogadorModel.fromJson(Map<String, dynamic> json) {
    return JogadorModel(
      idJogador: _parseInt(
        json['idJogador'] ?? json['id_jogador'] ?? json['id'],
      ),
      nomeJogador: (json['nomeJogador'] ?? json['nome'] ?? '').toString(),
      posicaoJogador: (json['posicaoJogador'] ?? json['posicao'] ?? '')
          .toString(),
      idEquipeJogador: _parseInt(
        json['idEquipeJogador'] ?? json['id_equipe_fk'] ?? json['idEquipe'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idJogador != null) 'idJogador': idJogador,
      'nomeJogador': nomeJogador,
      'posicaoJogador': posicaoJogador,
      'idEquipeJogador': idEquipeJogador,
    };
  }
}
