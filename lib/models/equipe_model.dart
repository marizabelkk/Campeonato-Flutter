class EquipeModel {
  int? idEquipe;
  String nomeEquipe;
  String cidadeEquipe;

  EquipeModel({
    this.idEquipe,
    required this.nomeEquipe,
    required this.cidadeEquipe,
  });

  factory EquipeModel.fromJson(Map<String, dynamic> json) {
    return EquipeModel(
      idEquipe: json['idEquipe'] ?? json['id'],
      nomeEquipe: json['nomeEquipe'] ?? json['nome'] ?? '',
      cidadeEquipe: json['cidadeEquipe'] ?? json['cidade'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idEquipe != null) 'idEquipe': idEquipe,
      'nomeEquipe': nomeEquipe,
      'cidadeEquipe': cidadeEquipe,
    };
  }
}