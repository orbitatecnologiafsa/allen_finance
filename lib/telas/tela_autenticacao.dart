import 'package:controle_financeiro/componentes/snackbar.dart';
import 'package:controle_financeiro/servicos/autenticacao_servico.dart';
import 'package:flutter/material.dart';
import '../componentes/decoracao_campo_autentificacao.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart'; 

class TelaAutenticacao extends StatelessWidget {
  const TelaAutenticacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/image/logo.png', height: 120),
          const Text(
            'EconoMi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  width: 345,
                  child: SignInButton(
                    text: 'Continuar com Google',
                    Buttons.Google,
                    onPressed: () async{
                      await AutenticacaoServico().signInWithGoogle(); // Autenticação com Google
                    },
                  )
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.inverseSurface),
                        const SizedBox(width: 8),
                        Text(
                          'Continuar com E-mail',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cadastro()),
                    );
                  },
                  child: const Text(
                    'Não tem uma conta? Cadastre-se aqui',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKeyLogin = GlobalKey<FormState>(); // Chave global para o formulário de login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  AutenticacaoServico _autenticacaoServico = AutenticacaoServico(); // Instância do serviço de autenticação
  bool _isLoading = false; // Estado para indicar carregamento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyLogin,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/image/logo.png', height: 120),
                  const Text(
                    'EconoMi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: getAuthenticationInputDecoration('E-mail', context),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o campo'; // Validação do campo de e-mail
                      }
                      if (value.length < 5 || !value.contains('@')) {
                        return 'E-mail inválido'; // Validação do e-mail
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _senhaController,
                    decoration: getAuthenticationInputDecoration('Senha', context),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o campo'; // Validação do campo de senha
                      }
                      if (value.length < 6) {
                        return 'A senha deve conter no minimo 6 caracteres'; // Validação da senha
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _isLoading ? null : () async {
                        if (_formKeyLogin.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          String? erro = await _autenticacaoServico.logarUsuario(
                            email: _emailController.text,
                            senha: _senhaController.text
                          );
                          setState(() {
                            _isLoading = false;
                          });
                          if(erro != null){
                            mostrarSnackbar(context: context, mensagem: erro); // Mostra Snackbar em caso de erro
                          } else {
                            Navigator.pop(context); // Volta para a tela anterior em caso de sucesso
                          }
                        }
                      },
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.inverseSurface
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Cadastro extends StatefulWidget {
  Cadastro({super.key});

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKeyCadastro = GlobalKey<FormState>(); // Chave global para o formulário de cadastro
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  AutenticacaoServico _autenticacaoServico = AutenticacaoServico(); // Instância do serviço de autenticação

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyCadastro,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/image/logo.png', height: 120),
                  const Text(
                    'EconoMi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nomeController,
                    decoration: getAuthenticationInputDecoration('Nome', context),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o campo'; // Validação do campo de nome
                      }
                      if (value.length < 6) {
                        return 'O nome deve conter no minimo 6 caracteres'; // Validação do nome
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: getAuthenticationInputDecoration('E-mail', context),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o campo'; // Validação do campo de e-mail
                      }
                      if (value.length < 5 || !value.contains('@')) {
                        return 'E-mail inválido'; // Validação do e-mail
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _senhaController,
                    decoration: getAuthenticationInputDecoration('Senha', context),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o campo'; // Validação do campo de senha
                      }
                      if (value.length < 6) {
                        return 'A senha deve conter no minimo 6 caracteres'; // Validação da senha
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    decoration: getAuthenticationInputDecoration('Confirme a senha', context),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o campo'; // Validação do campo de confirmação de senha
                      }
                      if (value != _senhaController.text) {
                        return 'As senhas não coincidem'; // Validação da correspondência das senhas
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      if (_formKeyCadastro.currentState!.validate()) {
                        _autenticacaoServico.cadastrarUsuario(
                          nome: _nomeController.text, 
                          email: _emailController.text, 
                          senha: _senhaController.text,
                        ).then((String? erro){
                          //voltou com erro
                          if (erro != null) {
                            mostrarSnackbar(context: context, mensagem: erro); // Mostra Snackbar em caso de erro
                          }
                          else {
                            Navigator.pop(context); // Volta para a tela anterior em caso de sucesso
                          }
                        });
                      }
                    },
                    child:Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 16,
                         color: Theme.of(context).colorScheme.inverseSurface
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
