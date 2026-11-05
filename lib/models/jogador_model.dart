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

  factory JogadorModel.fromJson(Map<String, dynamic> json) {
    return JogadorModel(
      idJogador: json['idJogador'] ?? json['id'],
      nomeJogador: json['nomeJogador'] ?? json['nome'] ?? '',
      posicaoJogador: json['posicaoJogador'] ?? json['posicao'] ?? '',
      idEquipeJogador: json['idEquipeJogador'] ?? json['id_equipe_fk'] ?? 0,
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