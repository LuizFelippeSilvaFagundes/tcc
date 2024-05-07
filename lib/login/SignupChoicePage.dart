import 'package:flutter/material.dart';
import 'signup_pacient.dart'; // Importe a tela de cadastro de paciente
import 'signup_psychologist.dart'; // Importe a tela de cadastro de psicólogo

class SignupChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonWidth = 300.0; // Largura desejada para os botões (aumentada)
    final buttonHeight = 60.0; // Altura desejada para os botões (nova)

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80), // Adiciona espaçamento apenas na parte superior
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/logo_attentive.png', // Coloque o caminho da sua imagem de logo
                  width: 200, // Defina a largura da imagem conforme necessário
                  height: 200, // Defina a altura da imagem conforme necessário
                ),
              ),
              SizedBox(
                width: buttonWidth, // Define a largura dos botões
                height: buttonHeight, // Define a altura dos botões
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    'Cadastro como Paciente',
                    overflow: TextOverflow.ellipsis, // Manter a frase em uma linha só
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Define os cantos como retos (quadrado)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: buttonWidth, // Define a largura dos botões
                height: buttonHeight, // Define a altura dos botões
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPsychologistPage()),
                    );
                  },
                  child: Text(
                    'Cadastro como Psicólogo',
                    overflow: TextOverflow.ellipsis, // Manter a frase em uma linha só
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Define os cantos como retos (quadrado)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
