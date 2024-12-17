import 'package:flutter/foundation.dart';

// Classe que representa o modelo para a categoria selecionada
class CategoriaModelo with ChangeNotifier {
  String _selectedCategory = ''; // Categoria selecionada

  // Método getter para obter a categoria selecionada
  String get selectedCategory => _selectedCategory;

  // Método para definir a categoria selecionada e notificar os ouvintes
  void setSelectedCategory(String value) {
    _selectedCategory = value; // Define a categoria selecionada com o novo valor
    notifyListeners(); // Notifica os ouvintes (widgets) que estão escutando as mudanças neste modelo
  }
}
