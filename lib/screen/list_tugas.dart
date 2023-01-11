import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/home_screen.dart';
import 'package:sku_pramuka/screen/profile_screen.dart';
import 'package:sku_pramuka/screen/tugas_screen.dart';
import 'package:sku_pramuka/service/auth.dart';
import 'package:sku_pramuka/widgets/card_tugas.dart';

final List<Widget> _children = [HomePage(), ListTugas(), ProfilePage()];

class ListTugas extends StatefulWidget {
  const ListTugas({super.key});

  @override
  State<ListTugas> createState() => _ListTugasState();
}

class _ListTugasState extends State<ListTugas> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthClass authClass = AuthClass();

  Map<String, dynamic> progress = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 78, 108, 80),
        title: Text(
          "Tugas",
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tugas').orderBy("no").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              reverse: false,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return CardTugas(
                    title: map["nama"],
                    iconData: Icons.directions_run,
                    iconColor: Colors.black54,
                    iconBgColor: Colors.white,
                    check: check(map["uid"]));
              },
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: onTap,
        currentIndex: 1,
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

  void init() async {
    await _firestore
        .collection("siswa")
        .doc(_auth.currentUser!.uid)
        .collection("progress")
        .get()
        .then((value) {
      for (var doc in value.docs) {
        progress[doc.data()["tugas"].toString()] = doc.data();
      }
    });
    setState(() {});
  }

  void onTap(int index) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _children[index]));
  }

  bool check(String uid) {
    return progress[uid] != null ? true : false;
  }
}
