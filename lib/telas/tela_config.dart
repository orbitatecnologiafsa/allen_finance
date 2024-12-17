import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import '../componentes/drawer.dart';
import '../componentes/appbar_personalizada.dart';

class TelaConfig extends StatelessWidget {
  const TelaConfig({super.key});

  @override
  Widget build(BuildContext context) {

    // Lista de widgets de botões
    List<Widget> _buttonsWidget = [
      Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(Icons.palette_outlined, color: Colors.blue), 
            const SizedBox(width: 8),
            const Text('Tema:', style: TextStyle(fontSize: 17)),
            const Spacer(),
            Row(
              children: [
                CustomSlidingSegmentedControl<int>(
                  initialValue: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light 
                  ? 1
                  : AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? 2
                  : 3, // Define o valor inicial do controle deslizante com base no tema atual
                  children: const {
                    1: Icon(Icons.light_mode),
                    2: Icon(Icons.dark_mode),
                    3: Icon(Icons.brightness_auto_outlined),
                  },
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(
                          0.0,
                          0.2,
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(microseconds: 300),
                  curve: Curves.easeInToLinear,
                  onValueChanged: (tema) {
                    AdaptiveTheme.of(context).setThemeMode(
                      tema == 1
                          ? AdaptiveThemeMode.light
                          : tema == 2
                              ? AdaptiveThemeMode.dark
                              : AdaptiveThemeMode.system, // Atualiza o modo de tema com base na seleção do usuário
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
      InkWell(
        borderRadius: BorderRadius.circular(60),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Sobre"),
                content: const Text("Versão: 1.0.0"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Fechar'),
                  ),
                ],
              );
            });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Sobre', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ),
  ];
    return Scaffold(
      appBar: const CustomAppBar(title: 'Configurações'),
      drawer: const Drawer(
        child: TelaDrawer(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: _buttonsWidget // Adiciona os widgets de botões à coluna
            ),
          )
        ]
      ),
    );
  }
}
