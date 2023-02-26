import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/app_colors.dart';
import 'package:whatsappweb/modules/sign_up/presenter/controllers/sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpController signInController;

  @override
  void initState() {
    super.initState();
    signInController = Modular.get<SignUpController>();
  }

  _selecionarImagem() async {
    //Selecionar arquivo
    FilePickerResult? resultado =
        await FilePicker.platform.pickFiles(type: FileType.image);

    File file = File(resultado?.files.single.path as String);

    //Recuperar o arquivo
    setState(() {
      signInController.arquivoImagemSelecionado = file.readAsBytesSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: AppColors.corFundo,
        width: larguraTela,
        height: alturaTela,
        child: Stack(
          children: [
            Positioned(
                child: Container(
              width: larguraTela,
              height: alturaTela * 0.5,
              color: AppColors.corPrimaria,
            )),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                      padding: EdgeInsets.all(40),
                      width: 500,
                      child: Column(
                        children: [
                          //Imagem perfil com botão
                          ClipOval(
                            child: signInController.arquivoImagemSelecionado !=
                                    null
                                ? Image.memory(
                                    signInController.arquivoImagemSelecionado!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'imagens/perfil.png',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                          ),

                          SizedBox(
                            height: 8,
                          ),

                          OutlinedButton(
                              onPressed: _selecionarImagem,
                              child: Text('Selecionar foto')),

                          SizedBox(
                            height: 8,
                          ),

                          //Caixa de texto nome
                          TextField(
                            keyboardType: TextInputType.text,
                            controller: signInController.controllerNome,
                            decoration: InputDecoration(
                                hintText: 'Nome',
                                labelText: 'Nome',
                                suffixIcon: Icon(Icons.person_outline)),
                          ),

                          //Caixa de texto email
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: signInController.controllerEmail,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                labelText: 'Email',
                                suffixIcon: Icon(Icons.mail_outline)),
                          ),

                          //Caixa de texto senha
                          TextField(
                            keyboardType: TextInputType.text,
                            controller: signInController.controllerSenha,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Senha',
                                labelText: 'Senha',
                                suffixIcon: Icon(Icons.lock_outline)),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          //Botão
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                signInController.validarCampos();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.corPrimaria),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Cadastro',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Modular.to.navigate('/sign-in');
                            },
                            child: Text('Logar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
