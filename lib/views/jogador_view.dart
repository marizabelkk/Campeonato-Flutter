import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/jogador_view_model.dart';
import '../models/jogador_model.dart';
import '../utils/api_response.dart';

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
    final nomeController = TextEditingController(
      text: jogador?.nomeJogador ?? '',
    );
    final posicaoController = TextEditingController(
      text: jogador?.posicaoJogador ?? '',
    );
    final idEquipeController = TextEditingController(
      text: jogador?.idEquipeJogador.toString() ?? '1',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(jogador == null ? "Cadastrar Jogador" : "Editar Jogador"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome do Jogador"),
            ),
            TextField(
              controller: posicaoController,
              decoration: const InputDecoration(labelText: "Posição"),
            ),
            TextField(
              controller: idEquipeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "ID da Equipe"),
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
              final vm = Provider.of<JogadorViewModel>(context, listen: false);
              final nome = nomeController.text.trim();
              final posicao = posicaoController.text.trim();
              final idEq = int.tryParse(idEquipeController.text.trim());
              if (nome.isEmpty ||
                  posicao.isEmpty ||
                  idEq == null ||
                  idEq <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Informe nome, posição e um ID de equipe válido.',
                    ),
                  ),
                );
                return;
              }
              try {
                if (jogador == null) {
                  await vm.cadastrarJogador(nome, posicao, idEq);
                } else if (jogador.idJogador != null &&
                    jogador.idJogador! > 0) {
                  await vm.atualizarJogador(
                    jogador.idJogador!,
                    nome,
                    posicao,
                    idEq,
                  );
                } else {
                  throw Exception('A API não retornou o ID deste jogador.');
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

  Future<void> _excluirJogador(JogadorModel jogador) async {
    final id = jogador.idJogador;
    if (id == null || id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A API não retornou o ID deste jogador; não é possível excluir.',
          ),
        ),
      );
      return;
    }
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir jogador?'),
        content: Text('Deseja excluir ${jogador.nomeJogador}?'),
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
      await context.read<JogadorViewModel>().deletarJogador(id);
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
        title: const Text("Jogadores"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<JogadorViewModel>(
        builder: (context, vm, child) {
          if (vm.carregando) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: vm.jogadores.length,
            itemBuilder: (context, index) {
              final item = vm.jogadores[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(
                  item.nomeJogador,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item.posicaoJogador),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _abrirFormulario(jogador: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _excluirJogador(item),
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
