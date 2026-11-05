import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/equipe_model.dart';
import '../models/partida_model.dart';
import '../utils/api_response.dart';
import '../view_models/equipe_view_model.dart';
import '../view_models/partida_view_model.dart';

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
      context.read<PartidaViewModel>().buscarPartidas();
      context.read<EquipeViewModel>().buscarEquipes();
    });
  }

  Future<void> _abrirFormulario({PartidaModel? partida}) async {
    final equipeVm = context.read<EquipeViewModel>();
    if (equipeVm.equipes.isEmpty) await equipeVm.buscarEquipes();
    if (!mounted) return;

    final equipes = equipeVm.equipes
        .where((equipe) => (equipe.idEquipe ?? 0) > 0)
        .toList();
    if (equipes.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cadastre ao menos duas equipes para criar uma partida.',
          ),
        ),
      );
      return;
    }

    final idsEquipes = equipes.map((equipe) => equipe.idEquipe!).toSet();
    int idCasa = idsEquipes.contains(partida?.idEquipeCasa)
        ? partida!.idEquipeCasa
        : equipes.first.idEquipe!;
    int idVisitante =
        idsEquipes.contains(partida?.idEquipeVisitante) &&
            partida?.idEquipeVisitante != idCasa
        ? partida!.idEquipeVisitante
        : equipes.firstWhere((equipe) => equipe.idEquipe != idCasa).idEquipe!;
    final dataController = TextEditingController(
      text:
          partida?.dataPartida ??
          DateTime.now().toIso8601String().split('T').first,
    );
    final placarCasaController = TextEditingController(
      text: partida?.placarEquipeCasa.toString() ?? '0',
    );
    final placarVisitanteController = TextEditingController(
      text: partida?.placarEquipeVisitante.toString() ?? '0',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, atualizarDialogo) => AlertDialog(
          title: Text(partida == null ? 'Cadastrar Partida' : 'Editar Partida'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    labelText: 'Data (AAAA-MM-DD)',
                  ),
                ),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Equipe da casa',
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: idCasa,
                      isExpanded: true,
                      items: equipes.map(_itemEquipe).toList(),
                      onChanged: (id) {
                        if (id == null) return;
                        atualizarDialogo(() {
                          idCasa = id;
                          if (idVisitante == id) {
                            idVisitante = equipes
                                .firstWhere((equipe) => equipe.idEquipe != id)
                                .idEquipe!;
                          }
                        });
                      },
                    ),
                  ),
                ),
                TextField(
                  controller: placarCasaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gols de ${_nomeEquipe(equipes, idCasa)}',
                  ),
                ),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Equipe visitante',
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: idVisitante,
                      isExpanded: true,
                      items: equipes
                          .where((equipe) => equipe.idEquipe != idCasa)
                          .map(_itemEquipe)
                          .toList(),
                      onChanged: (id) {
                        if (id != null) {
                          atualizarDialogo(() => idVisitante = id);
                        }
                      },
                    ),
                  ),
                ),
                TextField(
                  controller: placarVisitanteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Gols de ${_nomeEquipe(equipes, idVisitante)}',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = dataController.text.trim();
                final golsCasa = int.tryParse(placarCasaController.text.trim());
                final golsVisitante = int.tryParse(
                  placarVisitanteController.text.trim(),
                );
                if (DateTime.tryParse(data) == null ||
                    golsCasa == null ||
                    golsCasa < 0 ||
                    golsVisitante == null ||
                    golsVisitante < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Confira a data e os placares informados.'),
                    ),
                  );
                  return;
                }

                try {
                  final vm = context.read<PartidaViewModel>();
                  if (partida == null) {
                    await vm.cadastrarPartida(
                      data,
                      golsCasa,
                      golsVisitante,
                      idCasa,
                      idVisitante,
                    );
                  } else if ((partida.idPartida ?? 0) > 0) {
                    await vm.atualizarPartida(
                      partida.idPartida!,
                      data,
                      golsCasa,
                      golsVisitante,
                      idCasa,
                      idVisitante,
                    );
                  } else {
                    throw Exception(
                      'A listagem da API não trouxe o ID da partida.',
                    );
                  }
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } catch (erro) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(mensagemErro(erro))));
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<int> _itemEquipe(EquipeModel equipe) => DropdownMenuItem(
    value: equipe.idEquipe!,
    child: Text(
      '${equipe.nomeEquipe} • ${equipe.cidadeEquipe} (ID ${equipe.idEquipe})',
    ),
  );

  String _nomeEquipe(List<EquipeModel> equipes, int id) {
    for (final equipe in equipes) {
      if (equipe.idEquipe == id) return equipe.nomeEquipe;
    }
    return '';
  }

  Future<void> _excluirPartida(PartidaModel partida) async {
    final id = partida.idPartida;
    if (id == null || id <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A API não retornou o ID desta partida; não é possível excluir.',
          ),
        ),
      );
      return;
    }
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir partida?'),
        content: Text('Deseja excluir a partida $id?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    try {
      await context.read<PartidaViewModel>().deletarPartida(id);
    } catch (erro) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensagemErro(erro))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final equipes = context.watch<EquipeViewModel>().equipes;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partidas'),
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
              onRefresh: vm.buscarPartidas,
              child: ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text('Nenhuma partida cadastrada.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: vm.buscarPartidas,
            child: ListView.builder(
              itemCount: vm.partidas.length,
              itemBuilder: (context, index) {
                final item = vm.partidas[index];
                final nomeCasa = _nomeEquipe(equipes, item.idEquipeCasa);
                final nomeVisitante = _nomeEquipe(
                  equipes,
                  item.idEquipeVisitante,
                );
                final casa = item.equipeCasaNome.isNotEmpty
                    ? item.equipeCasaNome
                    : nomeCasa.isNotEmpty
                    ? nomeCasa
                    : 'Casa (${item.idEquipeCasa})';
                final visitante = item.equipeVisitanteNome.isNotEmpty
                    ? item.equipeVisitanteNome
                    : nomeVisitante.isNotEmpty
                    ? nomeVisitante
                    : 'Visitante (${item.idEquipeVisitante})';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.sports_soccer, color: Colors.white),
                    ),
                    title: Text(
                      '$casa ${item.placarEquipeCasa} x ${item.placarEquipeVisitante} $visitante',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Data: ${item.dataPartida} • ID da partida: ${item.idPartida ?? "não informado"}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _abrirFormulario(partida: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _excluirPartida(item),
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
