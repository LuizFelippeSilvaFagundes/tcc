import 'package:flutter/material.dart';

class SignupPsychologistPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _cipController = TextEditingController(); // Controlador para o campo CIP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro do Psicólogo'),
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
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirme sua Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cipController, // Vincule o controlador ao campo de entrada
              decoration: InputDecoration(
                labelText: 'Carteira do Psicólogo (CIP)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione a lógica de cadastro de psicólogo aqui
                // Você pode acessar os valores dos campos utilizando _emailController.text, _passwordController.text, _confirmPasswordController.text e _cipController.text
              },
              child: Text('Cadastrar como Psicólogo'),
            ),
          ],
        ),
      ),
    );
  }
}
