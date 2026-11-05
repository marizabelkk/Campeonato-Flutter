import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_models/dashboard_view_model.dart';
import 'view_models/equipe_view_model.dart';
import 'view_models/jogador_view_model.dart';
import 'view_models/partida_view_model.dart';
import 'views/dashboard_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => EquipeViewModel()),
        ChangeNotifierProvider(create: (_) => JogadorViewModel()),
        ChangeNotifierProvider(create: (_) => PartidaViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sistema Campeonato',
        home: DashboardView(),
      ),
    ),
  );
}
