import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sku_pramuka/screen/signin_screen.dart';
import 'package:sku_pramuka/service/google_auth.dart';
import 'package:sku_pramuka/widgets/card_tugas.dart';

class HomePage extends StatefulWidget {
  String name;
  HomePage({super.key, required this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "SKU Pramuka",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
          ),
          SizedBox(
            width: 25,
          ),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text("Senin, 23 Feb",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white))),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardTugas(
                title: "Tugas 1",
                iconData: Icons.directions_run,
                iconColor: Colors.black,
                iconBgColor: Colors.white,
                check: true,
              ),
              SizedBox(height: 10),
              CardTugas(
                title: "Tugas 2",
                iconData: Icons.local_grocery_store,
                iconColor: Colors.white,
                iconBgColor: Color(0xfff19733),
                check: false,
              ),
              SizedBox(height: 10),
              CardTugas(
                title: "Tugas 3",
                iconData: Icons.edit,
                iconColor: Colors.white,
                iconBgColor: Color(0xff2cc0d9),
                check: false,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        onTap: (value) {
          logout(context);
          authClass.signOut(context: context);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.indigoAccent,
                    Colors.purple,
                  ],
                ),
              ),
              child: Icon(
                Icons.task,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: "Tugas",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Future logout(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datang Kembali!'),
        ),
      );
      await _auth.signOut().then((value) => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const SignIn()))));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }
}
