import 'package:controle_financeiro/modelos/lista_modelos.dart';
import 'package:controle_financeiro/servicos/fireStore_servico.dart';
import 'package:flutter/material.dart';
import '../componentes/drawer.dart';
import 'tela_adicionar.dart';
import '../componentes/appbar_personalizada.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  _TelaInicioState createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  late ThemeData themeData; // Armazena o tema atual do app
  final FireStoreServico servico = FireStoreServico();

  // Mapeia categorias para ícones correspondentes
  final iconeMap = {
    'Comida': Icons.dining,
    'Compras': Icons.shopping_cart,
    'Roupas': Icons.checkroom,
    'Viagens': Icons.airplane_ticket,
    'Estimação': Icons.pets,
    'Carro': Icons.directions_car,
    'Saúde': Icons.local_hospital,
    'Eletrônicos': Icons.phone_android,
    'Transporte': Icons.directions_bus,
    'Educação': Icons.school,
    'Lazer': Icons.beach_access,
    'Salário': Icons.monetization_on,
    'Investimentos': Icons.trending_up,
    'Meio Período': Icons.access_time,
    'Prêmios': Icons.card_giftcard,
  };

  // Armazena o ano e mês selecionados
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  // Lista de anos para o dropdown
  List<int> years = List<int>.generate(10, (index) => DateTime.now().year - index);
  // Lista de meses para o dropdown
  List<String> months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context); // Obtém o tema atual do contexto
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Controle Financeiro',
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue!; // Atualiza o ano selecionado
                        });
                      },
                      items: years.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()), // Mostra o ano no dropdown
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<int>(
                      value: selectedMonth,
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = newValue!; // Atualiza o mês selecionado
                        });
                      },
                      items: List.generate(12, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text(months[index]), // Mostra o mês no dropdown
                        );
                      }),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: servico.conectarStreamDespesas(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Erro ao carregar dados.'));
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('Ainda nenhuma item adicionado!'));
                    } else {
                      List<AdicionarModelo> listaItens = snapshot.data!.docs.map((doc) {
                        return AdicionarModelo.fromMap(doc.data() as Map<String, dynamic>);
                      }).toList();

                      List<AdicionarModelo> filteredItems = listaItens.where((item) {
                        DateTime itemDate = item.data;
                        return itemDate.year == selectedYear && itemDate.month == selectedMonth;
                      }).toList();

                      // Calcula total de despesas
                      double totalDespesas = filteredItems
                          .where((item) => item.categoria == 'Despesas' || item.categoria == '')
                          .fold(0.0, (sum, item) => sum + item.valor);

                      // Calcula total de rendas
                      double totalRendas = filteredItems
                          .where((item) => item.categoria == 'Rendas')
                          .fold(0.0, (sum, item) => sum + item.valor);

                      double saldo = totalRendas - totalDespesas; // Calcula o saldo

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Despesas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'R\$${totalDespesas.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeData.colorScheme.inverseSurface,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Rendas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'R\$${totalRendas.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeData.colorScheme.inverseSurface,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Saldo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'R\$${saldo.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeData.colorScheme.inverseSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const Drawer(
        child: TelaDrawer(), // Mostra o menu lateral personalizado
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaAdicionar()),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
      body: StreamBuilder(
        stream: servico.conectarStreamDespesas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Ainda nenhuma item adicionado!'));
          } else {
            List<AdicionarModelo> listaItens = snapshot.data!.docs.map((doc) {
              return AdicionarModelo.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            // Filtra itens pelo ano e mês selecionados
            List<AdicionarModelo> filteredItems = listaItens.where((item) {
              DateTime itemDate = item.data;
              return itemDate.year == selectedYear && itemDate.month == selectedMonth;
            }).toList();

            return ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                AdicionarModelo adicionarModelo = filteredItems[index];
                return ListTile(
                  leading: Material(
                    shape: const CircleBorder(),
                    color: adicionarModelo.categoria == 'Despesas' || adicionarModelo.categoria == ''
                        ? Colors.red.withOpacity(0.4)
                        : Colors.blue.withOpacity(0.4),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(iconeMap[adicionarModelo.tipo]!, size: 28), // Mostra ícone correspondente ao tipo
                    ),
                  ),
                  title: Text(adicionarModelo.nota?.isNotEmpty == true
                      ? adicionarModelo.nota!
                      : adicionarModelo.tipo), // Mostra a nota ou tipo do item
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        adicionarModelo.categoria == 'Despesas' || adicionarModelo.categoria == ''
                            ? '-${adicionarModelo.valor.toString()}'
                            : adicionarModelo.valor.toString(),
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red), // Botão para deletar item
                        onPressed: () {
                          servico.deletarDespesas(adicionarModelo.id); // Deleta o item ao ser pressionado
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
