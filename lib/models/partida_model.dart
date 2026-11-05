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
      idPartida: _parseInt(json['idPartida'] ?? json['id']),
      dataPartida: json['dataPartida']?.toString() ?? '',
      placarEquipeCasa: _parseInt(json['placarCasa'] ?? json['placarEquipeCasa']),
      placarEquipeVisitante: _parseInt(json['placarVisitante'] ?? json['placarEquipeVisitante']),
      idEquipeCasa: json['equipeCasa'] is int ? json['equipeCasa'] : _parseInt(json['idEquipeCasa']),
      idEquipeVisitante: json['equipeVisitante'] is int ? json['equipeVisitante'] : _parseInt(json['idEquipeVisitante']),
      equipeCasaNome: json['equipeCasa'] is String ? json['equipeCasa'] : (json['nomeEquipeCasa']?.toString() ?? 'Equipe Casa'),
      equipeVisitanteNome: json['equipeVisitante'] is String ? json['equipeVisitante'] : (json['nomeEquipeVisitante']?.toString() ?? 'Equipe Visitante'),
    );
  }
}