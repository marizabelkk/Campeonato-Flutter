class EquipeModel {
  int? idEquipe;
  String nomeEquipe;
  String cidadeEquipe;

  EquipeModel({
    this.idEquipe,
    required this.nomeEquipe,
    required this.cidadeEquipe,
  });

  static int? _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  factory EquipeModel.fromJson(Map<String, dynamic> json) {
    return EquipeModel(
      idEquipe: _parseId(
        json['idEquipe'] ??
            json['id_equipe'] ??
            json['id_equipe_fk'] ??
            json['id'],
      ),
      nomeEquipe: (json['nomeEquipe'] ?? json['nome'] ?? '').toString(),
      cidadeEquipe: (json['cidadeEquipe'] ?? json['cidade'] ?? '').toString(),
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
