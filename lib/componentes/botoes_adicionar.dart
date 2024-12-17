import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../modelos/categoria_modelo.dart';
import '../modelos/lista_modelos.dart';
import '../servicos/fireStore_servico.dart';
import '../telas/tela_inicio.dart';
import '../componentes/decoracao_campo_autentificacao.dart';

// Widget responsável por exibir um botão personalizado com um ícone e um rótulo
class CustomIconButton extends StatefulWidget {
  final IconData icon; // Ícone a ser exibido no botão
  final String label; // Rótulo do botão
  final AdicionarModelo? adicionar; // Objeto AdicionarModelo associado ao botão (opcional)

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.label,
    this.adicionar,
  }) : super(key: key);

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  final TextEditingController _notaCtrl = TextEditingController();
  final TextEditingController _valorCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FireStoreServico adicionarServico = FireStoreServico();
  bool isCarregando = false;
  bool _isPressed = false;
  late ThemeData themeData;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Column(
      children: [
        Material(
          shape: const CircleBorder(),
          color: _isPressed ? Colors.blue : Colors.blue.withOpacity(0.2),
          elevation: 10,
          child: IconButton(
            onPressed: () {
              setState(() {
                _isPressed = !_isPressed;
              });
              showModal().then((_) {
                setState(() {
                  _isPressed = false;
                });
              });
            },
            icon: Icon(widget.icon),
            iconSize: 28,
            color: themeData.colorScheme.inverseSurface,
          ),
        ),
        const SizedBox(height: 7.2),
        Text(
          widget.label,
          style: TextStyle(color: themeData.colorScheme.inverseSurface),
        ),
      ],
    );
  }

  // Método chamado quando o botão "Enviar" é clicado
  void enviarClicado() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isCarregando = true;
      });

      String nota = _notaCtrl.text;
      double valor = double.parse(_valorCtrl.text);
      CategoriaModelo categoria = Provider.of<CategoriaModelo>(context, listen: false);

      AdicionarModelo adicionar = AdicionarModelo(
        id: const Uuid().v1(),
        tipo: widget.label,
        valor: valor,
        data: selectedDate ?? DateTime.now(),
        nota: nota,
        categoria: categoria.selectedCategory,
      );

      // Adiciona o novo modelo de adição ao Firestore
      adicionarServico.adicionarDespesas(adicionar).then((value) {
        setState(() {
          isCarregando = false;
        });
      });

      // Navega para a tela inicial após adicionar o item
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TelaInicio()),
      );
    }
  }

  // Método que exibe o modal (bottom sheet) para adicionar uma nova despesa
  Future<void> showModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              boxShadow: const [
                BoxShadow(
                  color: Colors.blue,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, -10),
                )
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Campo de entrada para a nota
                        Row(
                          children: [
                            const Icon(Icons.description),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _notaCtrl,
                                decoration: getAuthenticationInputDecoration('Nota', context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Campo de entrada para o valor
                        Row(
                          children: [
                            const Icon(Icons.attach_money),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _valorCtrl,
                                decoration: getAuthenticationInputDecoration('Valor', context),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira um valor';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Seleção da data
                        Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  final DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setModalState(() {
                                      selectedDate = pickedDate;
                                    });
                                  }
                                },
                                child: Text(
                                  selectedDate == null
                                      ? 'Selecione uma data'
                                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                  style: TextStyle(color: themeData.colorScheme.onSurface),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Material(
                          color: Colors.blue,
                          shape: const CircleBorder(),
                          elevation: 10,
                          child: IconButton(
                            onPressed: () {
                              enviarClicado();
                            },
                            icon: Icon(Icons.check, color: themeData.colorScheme.inverseSurface),
                            iconSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
