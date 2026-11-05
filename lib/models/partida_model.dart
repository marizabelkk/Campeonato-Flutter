class PartidaModel {
  int? idPartida;
  String dataPartida;
  int placarEquipeCasa;
  int placarEquipeVisitante;
  int idEquipeCasa;
  int idEquipeVisitante;
  String equipeCasaNome;
  String equipeVisitanteNome;

  PartidaModel({
    this.idPartida,
    required this.dataPartida,
    required this.placarEquipeCasa,
    required this.placarEquipeVisitante,
    required this.idEquipeCasa,
    required this.idEquipeVisitante,
    this.equipeCasaNome = '',
    this.equipeVisitanteNome = '',
  });

  // Converte qualquer entrada da API (String, int, double, null) para int com segurança
  static int _parseInt(dynamic valor) {
    if (valor == null) return 0;
    if (valor is int) return valor;
    if (valor is double) return valor.toInt();
    if (valor is String) return int.tryParse(valor) ?? 0;
    return 0;
  }

  factory PartidaModel.fromJson(Map<String, dynamic> json) {
    return PartidaModel(
      idPartida: _parseInt(
        json['idPartida'] ??
            json['id_partida'] ??
            json['partida_id'] ??
            json['id_jogo'] ??
            json['id'],
      ),
      dataPartida: json['dataPartida']?.toString() ?? '',
      placarEquipeCasa: _parseInt(
        json['placarCasa'] ?? json['placarEquipeCasa'],
      ),
      placarEquipeVisitante: _parseInt(
        json['placarVisitante'] ?? json['placarEquipeVisitante'],
      ),
      idEquipeCasa: _parseInt(
        json['idEquipeCasa'] ??
            json['id_equipe_casa'] ??
            (json['equipeCasa'] is num ? json['equipeCasa'] : 0),
      ),
      idEquipeVisitante: _parseInt(
        json['idEquipeVisitante'] ??
            json['id_equipe_visitante'] ??
            (json['equipeVisitante'] is num ? json['equipeVisitante'] : 0),
      ),
      equipeCasaNome: json['equipeCasa'] is String
          ? json['equipeCasa']
          : (json['nomeEquipeCasa']?.toString() ?? ''),
      equipeVisitanteNome: json['equipeVisitante'] is String
          ? json['equipeVisitante']
          : (json['nomeEquipeVisitante']?.toString() ?? ''),
    );
  }
}
