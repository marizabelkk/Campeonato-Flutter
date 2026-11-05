# ⚽ Sistema de Gerenciamento de Campeonato Esportivo

Aplicativo mobile desenvolvido em **Flutter** para gerenciamento completo de campeonatos esportivos (equipes, jogadores e partidas), utilizando a arquitetura **MVVM (Model-View-ViewModel)** com **Provider** para gerenciamento de estado e consumo de **API REST JSON** via pacote `http`.

---

## 📌 Sumário
- [Funcionalidades](#-funcionalidades)
- [Arquitetura e Tecnologias](#-arquitetura-e-tecnologias)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Endpoints da API](#-endpoints-da-api)
- [Como Executar](#-como-executar)
- [Autor](#-autor)

---

## 🚀 Funcionalidades

- **Dashboard Geral**:
  - Exibição de cards informativos com contagem em tempo real de total de equipes, jogadores, partidas e gols marcados.
  - Menu de navegação lateral (*Drawer*).
- **Gerenciamento de Equipes (CRUD)**:
  - Listagem de equipes cadastradas com cidade de origem.
  - Cadastro, edição e remoção de equipes.
- **Gerenciamento de Jogadores (CRUD)**:
  - Listagem de jogadores com posição e vínculo à equipe.
  - Cadastro, edição e remoção de jogadores.
- **Gerenciamento de Partidas (CRUD)**:
  - Exibição detalhada dos confrontos com nomes dos times, placares e datas.
  - Cadastro, edição e remoção de partidas.

---

## 🛠️ Arquitetura e Tecnologias

O projeto foi estruturado seguindo o padrão de arquitetura **MVVM**:

- **Model**: Classes de dados (`EquipeModel`, `JogadorModel`, `PartidaModel`) responsáveis pelo mapeamento JSON (`fromJson` e `toJson`).
- **ViewModel**: Classes que herdam de `ChangeNotifier` para gerenciar a lógica de negócio, chamadas HTTP à API e notificar a interface sobre atualizações de estado.
- **View**: Telas da aplicação (`DashboardView`, `EquipeView`, `JogadorView`, `PartidaView`) reconstruídas reativamente via `Consumer` do **Provider**.

### Dependências principais (`pubspec.yaml`):
- [`flutter`](https://flutter.dev/)
- [`provider: ^6.0.5`](https://pub.dev/packages/provider) — Gerenciamento de estado reativo.
- [`http: ^1.1.0`](https://pub.dev/packages/http) — Consumo da API REST HTTP.

---

## 📂 Estrutura do Projeto

```text
lib/
├── models/
│   ├── equipe_model.dart
│   ├── jogador_model.dart
│   └── partida_model.dart
├── view_models/
│   ├── dashboard_view_model.dart
│   ├── equipe_view_model.dart
│   ├── jogador_view_model.dart
│   └── partida_view_model.dart
├── views/
│   ├── dashboard_view.dart
│   ├── equipe_view.dart
│   ├── jogador_view.dart
│   └── partida_view.dart
└── main.dart
```

---

## 🌐 Endpoints da API

A aplicação consome os seguintes endpoints do backend (altere o IP base em `view_models/` conforme o seu ambiente):

### 🛡️ Equipes
- `GET /listaequipes` — Listar equipes
- `POST /cadastraequipe` — Cadastrar equipe (`nomeEquipe`, `cidadeEquipe`)
- `PUT /atualizaequipe` — Atualizar equipe (`idEquipe`, `nomeEquipe`, `cidadeEquipe`)
- `DELETE /removeequipe` — Deletar equipe (`idEquipe`)

### 🏃 Jogadores
- `GET /listajogadores` — Listar jogadores
- `POST /cadastrajogador` — Cadastrar jogador (`nomeJogador`, `posicaoJogador`, `idEquipeJogador`)
- `PUT /atualizajogador` — Atualizar jogador (`idJogador`, `nomeJogador`, `posicaoJogador`, `idEquipeJogador`)
- `DELETE /removejogador` — Deletar jogador (`idJogador`)

### 🏟️ Partidas
- `GET /listapartidas` — Listar estatísticas de partidas
- `GET /listapartidasdetalhada` — Listar partidas com nomes das equipes
- `POST /cadastrapartida` — Cadastrar partida (`dataPartida`, `placarEquipeCasa`, `placarEquipeVisitante`, `idEquipeCasa`, `idEquipeVisitante`)
- `PUT /atualizapartida` — Atualizar partida (`idPartida`, `dataPartida`, `placarEquipeCasa`, `placarEquipeVisitante`, `idEquipeCasa`, `idEquipeVisitante`)
- `DELETE /removepartida` — Deletar partida (`idPartida`)

---

## 💻 Como Executar

1. **Clone o repositório ou navegue até a pasta do projeto**:
   ```bash
   cd sistema_campeonato
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Configure o IP do servidor**:
   Abra os arquivos em `lib/view_models/` e altere a variável `baseUrl` para o endereço IP do seu backend.
   ```dart
   final String baseUrl = "http://SEU_IP_AQUI";
   ```

4. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

---
