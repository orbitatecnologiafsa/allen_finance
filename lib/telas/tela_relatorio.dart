import 'package:flutter/material.dart';



class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  // Lista de meses
  List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  // Valores padrão para controle financeiro
  Map<String, double> orcamentoMensal = {};
  Map<String, double> dinheiroEntrou = {};
  Map<String, double> despesas = {};

  // Mês selecionado
  String? mesSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle Financeiro'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: mesSelecionado,
              onChanged: (String? newValue) {
                setState(() {
                  mesSelecionado = newValue;
                  // Inicializa valores para o novo mês, se ainda não existirem
                  if (orcamentoMensal[mesSelecionado!] == null) {
                    orcamentoMensal[mesSelecionado!] = 0.0;
                  }
                  if (dinheiroEntrou[mesSelecionado!] == null) {
                    dinheiroEntrou[mesSelecionado!] = 0.0;
                  }
                  if (despesas[mesSelecionado!] == null) {
                    despesas[mesSelecionado!] = 0.0;
                  }
                });
              },
              items: meses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Orçamento Mensal'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  orcamentoMensal[mesSelecionado!] =
                      double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Dinheiro que Entrou'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  dinheiroEntrou[mesSelecionado!] =
                      double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Despesas'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  despesas[mesSelecionado!] = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            if (mesSelecionado != null) ...[
              Text(
                'Relatório de $mesSelecionado',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Orçamento Mensal: ${orcamentoMensal[mesSelecionado!]}'),
              Text('Dinheiro que Entrou: ${dinheiroEntrou[mesSelecionado!]}'),
              Text('Despesas: ${despesas[mesSelecionado!]}'),
              Text(
                'Saldo: ${(dinheiroEntrou[mesSelecionado!]! - despesas[mesSelecionado!]!).toStringAsFixed(2)}',
                style: TextStyle(
                  color: (dinheiroEntrou[mesSelecionado!]! -
                              despesas[mesSelecionado!]!) >=
                          0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}