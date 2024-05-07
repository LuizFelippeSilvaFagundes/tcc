import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailPsicologoController = TextEditingController(); // Controlador para o campo de e-mail do psicólogo

  @override
  Widget build(BuildContext context) {
    final buttonWidth = 300.0; // Largura desejada para os botões (aumentada)
    final buttonHeight = 60.0; // Altura desejada para os botões (nova)
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_attentive.png', // Coloque o caminho da sua imagem de logo
              width: 200, // Defina a largura da imagem conforme necessário
              height: 200, // Defina a altura da imagem conforme necessário
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor:  Color(0xFF393232), // Cor de fundo personalizada
                contentPadding: EdgeInsets.symmetric(horizontal: 20), // Adiciona padding interno
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                filled: true,
                fillColor:  Color(0xFF393232), // Cor de fundo personalizada
                contentPadding: EdgeInsets.symmetric(horizontal: 20), // Adiciona padding interno
              ),
              obscureText: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirme sua Senha',
                filled: true,
                fillColor: Color(0xFF393232), // Cor de fundo personalizada
                contentPadding: EdgeInsets.symmetric(horizontal: 20), // Adiciona padding interno
              ),
              obscureText: true,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailPsicologoController,
              decoration: InputDecoration(
                labelText: 'Email do Psicólogo',
                filled: true,
                fillColor: Color(0xFF393232), // Cor de fundo personalizada
                contentPadding: EdgeInsets.symmetric(horizontal: 20), // Adiciona padding interno
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: buttonWidth, // Define a largura dos botões
              height: buttonHeight, // Define a altura dos botões
              child: ElevatedButton(
                onPressed: () {
                  // Adicione a lógica de cadastro aqui
                  // Você pode acessar os valores dos campos utilizando _emailController.text, _passwordController.text, _confirmPasswordController.text e _emailPsicologoController.text
                },
                child: Text('Cadastrar-se'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Deixa o botão quadrado
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
