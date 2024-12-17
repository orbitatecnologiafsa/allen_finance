import 'package:controle_financeiro/modelos/categoria_modelo.dart';
import 'package:controle_financeiro/telas/tela_inicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'telas/tela_autenticacao.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // Inicia o aplicativo usando MultiProvider para gerenciamento de estado
  runApp(
    MultiProvider(
      providers: [
        // Provedor para CategoriaModelo
        ChangeNotifierProvider(create: (_) => CategoriaModelo()),
      ],
      // Inicia o app principal com o tema salvo
      child: FinanceiroApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class FinanceiroApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  // Construtor da classe FinanceiroApp que recebe o modo de tema salvo
  const FinanceiroApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      // Define o tema claro
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      // Define o tema escuro
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      // Define o tema inicial do aplicativo como padrão do sistema de acordo com o dispositivo
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: const RoteadorTela(),
      ),
      debugShowFloatingThemeButton: true,
    );
  }
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Escuta mudanças na autenticação do usuário
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Se houver dados do usuário, navega para TelaInicio
          return const TelaInicio();
        } else if (snapshot.hasError) {
          // Se houver erro, exibe a mensagem de erro
          return Text('Error: ${snapshot.error}');
        } else {
          // Se estiver aguardando ou sem dados, mostra um indicador de carregamento ou TelaAutenticacao
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : const TelaAutenticacao();
        }
      },
    );
  }
}
