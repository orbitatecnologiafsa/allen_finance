// Classe que define o modelo para adicionar despesas ou rendas
class AdicionarModelo {
  String id;
  String tipo; 
  String? nota; 
  double valor; 
  DateTime data;
  String categoria;

  // Construtor da classe
  AdicionarModelo({
    required this.id,
    required this.data,
    required this.valor,
    required this.tipo,
    this.nota = '', // Nota padrão é vazia se não for fornecida
    required this.categoria,
  });

  // Construtor nomeado para criar um objeto AdicionarModelo a partir de um mapa de dados
  AdicionarModelo.fromMap(Map<String, dynamic> map)
      : id = map['id'], // Inicializa o ID com o valor do mapa
        tipo = map['tipo'], // Inicializa o tipo com o valor do mapa
        valor = map['valor'], // Inicializa o valor com o valor do mapa
        nota = map['nota'] ?? '', // Inicializa a nota com o valor do mapa (ou vazio se for nulo)
        categoria = map['categoria'], // Inicializa a categoria com o valor do mapa
        data = DateTime.parse(map['data']); // Inicializa a data convertendo a string do mapa para DateTime

  // Método para converter o objeto AdicionarModelo em um mapa de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'valor': valor,
      'nota': nota,
      'categoria': categoria,
      'data': data.toIso8601String(), // Converte a data para uma string no formato ISO 8601
    };
  }
}
