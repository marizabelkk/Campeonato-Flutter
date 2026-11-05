import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/dashboard_view_model.dart';
import 'equipe_view.dart';
import 'jogador_view.dart';
import 'partida_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(
        context,
        listen: false,
      ).carregarDashboard();
    });
  }

  Widget _buildCard(String titulo, String valor, IconData icone, Color cor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icone, color: cor, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Geral"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[800]),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_soccer, size: 48, color: Colors.amber),
                  SizedBox(height: 8),
                  Text(
                    "Sistema Campeonato",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Equipes"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EquipeView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Jogadores"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JogadorView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports),
              title: const Text("Partidas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PartidaView()),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, vm, child) {
          if (vm.carregando) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: vm.carregarDashboard,
            child: ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [
                _buildCard(
                  "Total de Equipes",
                  "${vm.totalEquipes}",
                  Icons.groups,
                  Colors.amber[800]!,
                ),
                _buildCard(
                  "Total de Jogadores",
                  "${vm.totalJogadores}",
                  Icons.person,
                  Colors.amber[800]!,
                ),
                _buildCard(
                  "Total de Partidas",
                  "${vm.totalPartidas}",
                  Icons.sports_soccer,
                  Colors.amber[800]!,
                ),
                _buildCard(
                  "Gols Marcados",
                  "${vm.golsMarcados}",
                  Icons.emoji_events,
                  Colors.amber[800]!,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
