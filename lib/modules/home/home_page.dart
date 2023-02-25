import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:whatsappweb/modules/home/chats_list_tab.dart';
import 'package:whatsappweb/modules/home/contacts_list_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  child: ChatsListTab(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ContactsListTab(),
                )
              ],
            ),
          ),
        ));
  }
}
