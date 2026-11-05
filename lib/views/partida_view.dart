import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/partida_view_model.dart';
import '../models/partida_model.dart';

class PartidaView extends StatefulWidget {
  const PartidaView({super.key});

  @override
  State<PartidaView> createState() => _PartidaViewState();
}

class _PartidaViewState extends State<PartidaView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartidaViewModel>(context, listen: false).buscarPartidasDetalhadas();
    });
  }

  void _abrirFormulario({PartidaModel? partida}) {
    final dataController = TextEditingController(text: partida?.dataPartida ?? '2026-05-20');
    final placarCasaController = TextEditingController(text: partida?.placarEquipeCasa.toString() ?? '0');
    final placarVisController = TextEditingController(text: partida?.placarEquipeVisitante.toString() ?? '0');
    final idCasaController = TextEditingController(text: partida?.idEquipeCasa.toString() ?? '1');
    final idVisController = TextEditingController(text: partida?.idEquipeVisitante.toString() ?? '2');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(partida == null ? "Cadastrar Partida" : "Editar Partida"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: dataController, decoration: const InputDecoration(labelText: "Data (AAAA-MM-DD)")),
              TextField(controller: idCasaController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "ID Equipa Casa")),
              TextField(controller: placarCasaController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Placar Casa")),
              TextField(controller: idVisController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "ID Equipa Visitante")),
              TextField(controller: placarVisController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Placar Visitante")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final vm = Provider.of<PartidaViewModel>(context, listen: false);
              if (partida == null) {
                vm.cadastrarPartida(
                  dataController.text,
                  int.tryParse(placarCasaController.text) ?? 0,
                  int.tryParse(placarVisController.text) ?? 0,
                  int.tryParse(idCasaController.text) ?? 1,
                  int.tryParse(idVisController.text) ?? 2,
                );
              } else {
                vm.atualizarPartida(
                  partida.idPartida ?? 1,
                  dataController.text,
                  int.tryParse(placarCasaController.text) ?? 0,
                  int.tryParse(placarVisController.text) ?? 0,
                  int.tryParse(idCasaController.text) ?? 1,
                  int.tryParse(idVisController.text) ?? 2,
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Partidas"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<PartidaViewModel>(
        builder: (context, vm, child) {
          if (vm.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.partidas.isEmpty) {
            return RefreshIndicator(
              onRefresh: vm.buscarPartidasDetalhadas,
              child: ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Nenhuma partida cadastrada.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: vm.buscarPartidasDetalhadas,
            child: ListView.builder(
              itemCount: vm.partidas.length,
              itemBuilder: (context, index) {
                final item = vm.partidas[index];
                final casa = item.equipeCasaNome.isNotEmpty ? item.equipeCasaNome : "Casa (${item.idEquipeCasa})";
                final visitante = item.equipeVisitanteNome.isNotEmpty ? item.equipeVisitanteNome : "Visitante (${item.idEquipeVisitante})";

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.sports_soccer, color: Colors.white),
                    ),
                    title: Text(
                      "$casa ${item.placarEquipeCasa} x ${item.placarEquipeVisitante} $visitante",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Data: ${item.dataPartida}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _abrirFormulario(partida: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => vm.deletarPartida(item.idPartida ?? (index + 1)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}