import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; 

class AutenticacaoServico {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Método para cadastrar um novo usuário com e-mail e senha
  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      // Cria um usuário com e-mail e senha no Firebase
      UserCredential userCredencial = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Atualiza o nome de exibição do usuário com o nome fornecido
      await userCredencial.user!.updateDisplayName(nome);

      return null; // Retorna null se o cadastro for bem-sucedido
    } on FirebaseAuthException catch (e) {
      // Trata os erros específicos do Firebase Auth
      if (e.code == 'email-already-in-use') {
        return 'E-mail já cadastrado';
      }
      return 'Erro desconhecido'; 
    }
  }

  // Método para realizar o login de um usuário com e-mail e senha
  Future<String?> logarUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      // Realiza o login do usuário com e-mail e senha no Firebase
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      return null; // Retorna null se o login for bem-sucedido
    } on FirebaseAuthException catch (e) {
      // Trata os erros específicos do Firebase Auth
      if (e.code == 'invalid-credential') {
        return 'E-mail não cadastrado'; 
      }
      return 'Erro desconhecido'; 
    }
  }

  // Método para realizar o logout do usuário
  Future<void> deslogarUsuario() async {
    await firebaseAuth.signOut(); // Realiza o logout do usuário no Firebase
  }

  // Método para realizar a autenticação do usuário com o Google
  Future<User?> signInWithGoogle() async {
    // Realiza o login do usuário com o Google usando a biblioteca Google Sign-In
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtém as credenciais de autenticação do Google
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Cria uma credencial de autenticação do Firebase usando as credenciais do Google
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Realiza o login do usuário no Firebase com a credencial do Google
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user; // Retorna o usuário autenticado
  }
}
