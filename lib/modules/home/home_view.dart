import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modules/home/lista_contatos.dart';
import 'package:whatsappweb/modules/home/lista_conversas.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("WhatsApp"),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              SizedBox(
                width: 3.0,
              ),
              IconButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Modular.to.navigate("/login");
                  },
                  icon: Icon(Icons.logout)),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: "Conversas",
                ),
                Tab(
                  text: "Contatos",
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListaConversas(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListaContatos(),
                )
              ],
            ),
          ),
        ));
  }
}
