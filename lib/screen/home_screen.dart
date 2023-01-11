import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/list_tugas.dart';
import 'package:sku_pramuka/screen/profile_screen.dart';
import 'package:sku_pramuka/screen/signin_screen.dart';
import 'package:sku_pramuka/service/auth.dart';
import 'package:sku_pramuka/widgets/card_tugas.dart';

final List<Widget> _children = [HomePage(), ListTugas(), ProfilePage()];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 108, 80),
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
            backgroundColor: Colors.black,
          ),
          SizedBox(
            width: 25,
          ),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(left: 22, bottom: 10),
                child: Text(
                    DateFormat("EEEE, d MMMM", "id_ID").format(DateTime.now()),
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
            children: <Widget>[],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: onTap,
        currentIndex: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color.fromARGB(255, 78, 108, 80),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
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
              Icons.account_circle_rounded,
              size: 32,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  void onTap(int index) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _children[index]));
  }
}
