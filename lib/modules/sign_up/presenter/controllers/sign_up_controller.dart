import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/core/domain/entities/user_entity.dart';
import 'package:whatsappweb/core/infra/models/user_model.dart';

class SignUpController {
  TextEditingController controllerNome =
      TextEditingController(text: 'Jamilton Damasceno');
  TextEditingController controllerEmail =
      TextEditingController(text: 'jamilton@gmail.com');
  TextEditingController controllerSenha =
      TextEditingController(text: '1234567');
  FirebaseAuth auth = Modular.get<FirebaseAuth>();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = Modular.get<FirebaseFirestore>();
  Uint8List? arquivoImagemSelecionado;

  // verificarUsuarioLogado(){
  //
  //   User? usuarioLogado = auth.currentUser;
  //
  //   if( usuarioLogado != null ){
  //     Modular.to.navigate('/');
  //   }
  //
  // }

  uploadImagem(UserEntity usuario) {
    Uint8List? arquivoSelecionado = arquivoImagemSelecionado;
    if (arquivoSelecionado != null) {
      Reference imagemPerfilRef =
          storage.ref('imagens/perfil/${usuario.idUsuario}.jpg');
      UploadTask uploadTask = imagemPerfilRef.putData(arquivoSelecionado);

      uploadTask.whenComplete(() async {
        String urImagem = await uploadTask.snapshot.ref.getDownloadURL();
        usuario.urlImagem = urImagem;

        //Atualiza url e nome nos dados do usuário
        await auth.currentUser?.updateDisplayName(usuario.nome);
        await auth.currentUser?.updatePhotoURL(usuario.urlImagem);

        final usuariosRef = firestore.collection('usuarios');

        final userMap = UserModel.fromEntity(usuario).toMap();

        usuariosRef.doc(usuario.idUsuario).set(userMap).then((value) {
          //tela principal
          Modular.to.navigate('/');
        });
      });
    }
  }

  validarCampos() async {
    String nome = controllerNome.text;
    String email = controllerEmail.text;
    String senha = controllerSenha.text;

    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty && senha.length > 6) {
        if (arquivoImagemSelecionado != null) {
          //Cadastro
          if (nome.isNotEmpty && nome.length >= 3) {
            await auth
                .createUserWithEmailAndPassword(email: email, password: senha)
                .then((auth) {
              //Upload
              String? idUsuario = auth.user?.uid;
              if (idUsuario != null) {
                UserEntity usuario = UserEntity(
                  idUsuario: idUsuario,
                  nome: nome,
                  email: email,
                );
                uploadImagem(usuario);
              }
              //print('Usuario cadastrado: $idUsuario');
            });
          } else {
            print('Nome inválido, digite ao menos 3 caracteres');
          }
        } else {
          print('Selecione uma imagem');
        }
      } else {
        print('Senha inválida');
      }
    } else {
      print('Email inválido');
    }
  }
}
