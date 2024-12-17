import 'package:controle_financeiro/servicos/autenticacao_servico.dart';
import 'package:controle_financeiro/telas/tala_graficos.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../telas/tela_config.dart';
import '../telas/tela_inicio.dart';
import '../telas/tela_relatorio.dart';

class TelaDrawer extends StatelessWidget {
  const TelaDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    final AutenticacaoServico autenticacaoServico = AutenticacaoServico();

    // Obtém o usuário atualmente logado
    final User? currentUser = autenticacaoServico.firebaseAuth.currentUser;

    // Cabeçalho do Drawer exibindo informações do usuário logado
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(currentUser != null ? currentUser.displayName ?? '' : ''),
      accountEmail: Text(currentUser != null ? currentUser.email ?? '' : ''),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: currentUser != null
            ? currentUser.photoURL != null
                ? Image.network(currentUser.photoURL!)
                : const FlutterLogo(size: 42.0)
            : const FlutterLogo(size: 42.0),
      ),
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
    );

    // Itens do Drawer
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader, // Adiciona o cabeçalho ao Drawer

        // Item "Início"
        ListTile(
          leading: const Icon(Icons.home, color: Colors.blue,),
          title: const Text('Inicio'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TelaInicio()),
          ),
        ),

        // Item "Gráfico"
        ListTile(
          leading: const Icon(Icons.pie_chart, color: Colors.blue),
          title: const Text('Gráfico'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TelaGrafico()),
          ),
        ),

        // Item "Relatório"
        ListTile(
          leading: const Icon(Icons.receipt_long, color: Colors.blue),
          title: const Text('Relatório'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FinancePage()),
          ),
        ),

        // Item "Configurações"
        ListTile(
          leading: const Icon(Icons.settings, color: Colors.blue),
          title: const Text('Configurações'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TelaConfig()),
          ),
        ),

        // Item "Sair"
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.blue),
          title: const Text('Sair'),
          onTap: () {
            autenticacaoServico.deslogarUsuario();
          },
        ),
      ],
    );

    return drawerItems; // Retorna a lista de itens do Drawer
  }
}
