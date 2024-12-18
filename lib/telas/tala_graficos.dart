import 'package:controle_financeiro/componentes/drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:controle_financeiro/modelos/lista_modelos.dart';
import 'package:controle_financeiro/servicos/fireStore_servico.dart';
import '../componentes/appbar_personalizada.dart';

class TelaGrafico extends StatefulWidget {
  @override
  _TelaGraficoState createState() => _TelaGraficoState();
}

class _TelaGraficoState extends State<TelaGrafico> {
  final FireStoreServico _servico = FireStoreServico();
  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateTime.now().month.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gráficos'),
      drawer: const Drawer(
        child: TelaDrawer(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Dropdown para selecionar o ano
                Row(
                  children: [
                    const Text("Ano: "),
                    DropdownButton<String>(
                      value: selectedYear,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                      items: <String>[
                        '2020',
                        '2021',
                        '2022',
                        '2023',
                        '2024',
                        '2025',
                        '2026'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // Dropdown para selecionar o mês
                Row(
                  children: [
                    const Text("Mês: "),
                    DropdownButton<String>(
                      value: selectedMonth,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                        });
                      },
                      items: List<String>.generate(12, (int index) => (index + 1).toString())
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _servico.conectarStreamDespesas(), // Stream para obter dados de despesas
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                  List<AdicionarModelo> listaItens = [];
                  for (var doc in snapshot.data!.docs) {
                    AdicionarModelo item = AdicionarModelo.fromMap(doc.data());
                    if (item.data.year.toString() == selectedYear && item.data.month.toString() == selectedMonth) {
                      listaItens.add(item);
                    }
                  }

                  if (listaItens.isEmpty) {
                    return const Center(child: Text('Nenhum item encontrado para o período selecionado!'));
                  }

                  // Cálculo das categorias e valores
                  Map<String, double> categorias = {};
                  for (var item in listaItens) {
                    if (categorias.containsKey(item.tipo)) {
                      categorias[item.tipo] = categorias[item.tipo]! + item.valor;
                    } else {
                      categorias[item.tipo] = item.valor;
                    }
                  }

                  double total = categorias.values.reduce((a, b) => a + b); // Total dos valores

                  // Ordenação das categorias por valor
                  List<MapEntry<String, double>> categoriasEscolhida = categorias.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  List<String> categoriasTop4 = categoriasEscolhida.take(4).map((e) => e.key).toList();
                  List<double> categoriasTop4Valores = categoriasEscolhida.take(4).map((e) => e.value).toList();
                  double outros = total - categoriasTop4Valores.reduce((a, b) => a + b); // Valor restante

                  List<Color> colors = Colors.primaries; // Cores para o gráfico

                  return Column(
                    children: [
                      // Gráfico de pizza
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      ...categoriasTop4.map((categoria) {
                                        return PieChartSectionData(
                                          value: categorias[categoria]!,
                                          color: colors[categoriasTop4.indexOf(categoria) % colors.length],
                                          radius: 50,
                                          title: '',
                                        );
                                      }),
                                      PieChartSectionData(
                                        value: outros,
                                        color: Colors.grey,
                                        radius: 50,
                                        title: '',
                                      ),
                                    ],
                                    centerSpaceRadius: 40,
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Legenda das categorias
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...categoriasTop4.map((categoria) {
                                    double porcentagem = (categorias[categoria]! / total) * 100;
                                    Color categoriaColor = colors[categoriasTop4.indexOf(categoria) % colors.length];
                                    return Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: categoriaColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            '$categoria: ${porcentagem.toStringAsFixed(2)}%',
                                            style: const TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  // Categoria 'Outros'
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Outros: ${((outros / total) * 100).toStringAsFixed(2)}%',
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Lista de categorias com valores e porcentagens
                      Expanded(
                        child: ListView(
                          children: [
                            ...categoriasEscolhida.map((entry) {
                              double porcentagem = (entry.value / total) * 100;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          '${porcentagem.toStringAsFixed(2)}%',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Barra de progresso
                                    LinearProgressIndicator(
                                      value: entry.value / total,
                                      color: Colors.blue,
                                      backgroundColor: Colors.grey[200],
                                      minHeight: 10,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.value.toStringAsFixed(2),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('Ainda nenhum item foi adicionado!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
