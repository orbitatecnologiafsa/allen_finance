import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:controle_financeiro/modelos/lista_modelos.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 


class FireStoreServico {
  String userId;
  
  FireStoreServico() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para adicionar uma nova despesa ao Firestore
  Future<void> adicionarDespesas(AdicionarModelo adicionarModelo) async {
    return await _firestore
        .collection(userId) // Nome da coleção é o userId, para armazenar os dados do usuário atual
        .doc(adicionarModelo.id) // ID do documento é o ID do modelo de despesa
        .set(adicionarModelo.toMap()); // Converte o modelo para um mapa e adiciona ao Firestore
  }

  // Método para obter um stream de despesas do Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamDespesas() {
    return _firestore.collection(userId).snapshots(); // Retorna um stream dos documentos na coleção do usuário
  }

  // Método para deletar uma despesa do Firestore pelo ID
  Future<void> deletarDespesas(String id) async {
    return _firestore.collection(userId).doc(id).delete(); // Deleta o documento com o ID especificado
  }
}
