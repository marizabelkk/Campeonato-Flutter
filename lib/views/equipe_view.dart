import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/equipe_view_model.dart';
import '../models/equipe_model.dart';
import '../utils/api_response.dart';

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
    final nomeController = TextEditingController(
      text: equipe?.nomeEquipe ?? '',
    );
    final cidadeController = TextEditingController(
      text: equipe?.cidadeEquipe ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(equipe == null ? "Cadastrar Equipe" : "Editar Equipe"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome da Equipe"),
            ),
            TextField(
              controller: cidadeController,
              decoration: const InputDecoration(labelText: "Cidade"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final vm = Provider.of<EquipeViewModel>(context, listen: false);
              final nome = nomeController.text.trim();
              final cidade = cidadeController.text.trim();
              if (nome.isEmpty || cidade.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe o nome e a cidade da equipe.'),
                  ),
                );
                return;
              }
              try {
                if (equipe == null) {
                  await vm.cadastrarEquipe(nome, cidade);
                } else if (equipe.idEquipe != null && equipe.idEquipe! > 0) {
                  await vm.atualizarEquipe(equipe.idEquipe!, nome, cidade);
                } else {
                  throw Exception('A API não retornou o ID desta equipe.');
                }
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (erro) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(mensagemErro(erro))));
                }
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  Future<void> _excluirEquipe(EquipeModel equipe) async {
    final id = equipe.idEquipe;
    if (id == null || id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A API não retornou o ID desta equipe; não é possível excluir.',
          ),
        ),
      );
      return;
    }
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir equipe?'),
        content: Text('Deseja excluir ${equipe.nomeEquipe}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    try {
      await context.read<EquipeViewModel>().deletarEquipe(id);
    } catch (erro) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensagemErro(erro))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipes"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<EquipeViewModel>(
        builder: (context, vm, child) {
          if (vm.carregando) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: vm.equipes.length,
            itemBuilder: (context, index) {
              final item = vm.equipes[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.shield)),
                title: Text(
                  item.nomeEquipe,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item.cidadeEquipe),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _abrirFormulario(equipe: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _excluirEquipe(item),
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
