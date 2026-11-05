import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/jogador_view_model.dart';
import '../models/jogador_model.dart';

class JogadorView extends StatefulWidget {
  const JogadorView({super.key});

  @override
  State<JogadorView> createState() => _JogadorViewState();
}

class _JogadorViewState extends State<JogadorView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JogadorViewModel>(context, listen: false).buscarJogadores();
    });
  }

  void _abrirFormulario({JogadorModel? jogador}) {
    final nomeController = TextEditingController(text: jogador?.nomeJogador ?? '');
    final posicaoController = TextEditingController(text: jogador?.posicaoJogador ?? '');
    final idEquipeController = TextEditingController(text: jogador?.idEquipeJogador.toString() ?? '1');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(jogador == null ? "Cadastrar Jogador" : "Editar Jogador"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: "Nome do Jogador")),
            TextField(controller: posicaoController, decoration: const InputDecoration(labelText: "Posição")),
            TextField(
              controller: idEquipeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "ID da Equipe"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final vm = Provider.of<JogadorViewModel>(context, listen: false);
              int idEq = int.tryParse(idEquipeController.text) ?? 1;
              if (jogador == null) {
                vm.cadastrarJogador(nomeController.text, posicaoController.text, idEq);
              } else {
                vm.atualizarJogador(jogador.idJogador!, nomeController.text, posicaoController.text, idEq);
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
      appBar: AppBar(title: const Text("Jogadores"), backgroundColor: Colors.blue[700], foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<JogadorViewModel>(
        builder: (context, vm, child) {
          if (vm.carregando) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: vm.jogadores.length,
            itemBuilder: (context, index) {
              final item = vm.jogadores[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(item.nomeJogador, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item.posicaoJogador),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _abrirFormulario(jogador: item)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => vm.deletarJogador(item.idJogador ?? 0),
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