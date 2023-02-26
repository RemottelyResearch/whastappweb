import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/app_colors.dart';
import 'package:whatsappweb/modules/sign_in/presenter/controllers/sign_in_controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late SignInController signInController;

  @override
  void initState() {
    super.initState();
    signInController = Modular.get<SignInController>();
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
                                  'Login',
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
                              Modular.to.navigate('/sign-up');
                            },
                            child: Text('Cadastrar'),
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
