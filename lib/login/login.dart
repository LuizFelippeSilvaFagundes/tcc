import 'package:flutter/material.dart';
import 'SignupChoicePage.dart';
import 'package:spacescape/screens/main_menu.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onSignUpPressed;

  const LoginPage({Key? key, this.onSignUpPressed}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40), // Adiciona margem horizontal
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Color(0xFF393232), // Cor de fundo personalizada
                    contentPadding: EdgeInsets.symmetric(horizontal: 20), // Adiciona padding interno
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40), // Adiciona margem horizontal
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    filled: true,
                    fillColor: Color(0xFF393232), // Cor de fundo personalizada
                    contentPadding: EdgeInsets.symmetric(horizontal: 20), // Adiciona padding interno
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Define borda como zero
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupChoicePage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Ainda sem cadastro? ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Cadastre-se',
                        style: TextStyle(
                          color: Colors.red, // Cor diferente para "Cadastre-se"
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          Positioned(
            top: 40,
            child: Image.asset(
              'assets/images/logo_attentive.png', // Coloque o caminho da imagem da sua logo
              width: 257, // Defina a largura da imagem conforme necessário
              height: 252, // Defina a altura da imagem conforme necessário
            ),
          ),
        ],
      ),
    );
  }

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Lógica de autenticação

    // Supondo que a autenticação foi bem-sucedida, navegue para o MainMenu
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainMenu()),
    );
  }
}
