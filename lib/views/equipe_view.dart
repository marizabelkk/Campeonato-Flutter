import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/equipe_view_model.dart';
import '../models/equipe_model.dart';

class EquipeView extends StatefulWidget {
  const EquipeView({super.key});

  @override
  State<EquipeView> createState() => _EquipeViewState();
}

class _EquipeViewState extends State<EquipeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EquipeViewModel>(context, listen: false).buscarEquipes();
    });
  }

  void _abrirFormulario({EquipeModel? equipe}) {
    final nomeController = TextEditingController(text: equipe?.nomeEquipe ?? '');
    final cidadeController = TextEditingController(text: equipe?.cidadeEquipe ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(equipe == null ? "Cadastrar Equipe" : "Editar Equipe"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: "Nome da Equipe")),
            TextField(controller: cidadeController, decoration: const InputDecoration(labelText: "Cidade")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final vm = Provider.of<EquipeViewModel>(context, listen: false);
              if (equipe == null) {
                vm.cadastrarEquipe(nomeController.text, cidadeController.text);
              } else {
                vm.atualizarEquipe(equipe.idEquipe!, nomeController.text, cidadeController.text);
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
      appBar: AppBar(title: const Text("Equipes"), backgroundColor: Colors.blue[700], foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<EquipeViewModel>(
        builder: (context, vm, child) {
          if (vm.carregando) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: vm.equipes.length,
            itemBuilder: (context, index) {
              final item = vm.equipes[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.shield)),
                title: Text(item.nomeEquipe, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item.cidadeEquipe),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _abrirFormulario(equipe: item)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => vm.deletarEquipe(item.idEquipe ?? 0),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}