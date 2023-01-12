import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/home_screen.dart';
import 'package:sku_pramuka/screen/profile_screen.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';
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
  bool _isLoading = false;

  List<String> kategori = [];
  Map<String, String> userMap = {"Kecakapan": "Dis"};
  Map<String, dynamic> progress = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
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
          if (snapshot.hasData && !_isLoading) {
            return ListView.builder(
              reverse: false,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                if ((map["no"] != 1 ||
                    map["kategori"].contains(userMap["agama"]!.toLowerCase()) &&
                        map["kecakapan"] ==
                            userMap["kecakapan"]!.toLowerCase())) {
                  kategori = (map["kategori"] as List)
                      .map((item) => item as String)
                      .toList();
                  return CardTugas(
                    title: map["nama"],
                    iconData: Icons.directions_run,
                    iconColor: Colors.black54,
                    iconBgColor: Colors.white,
                    check: check(map["uid"]),
                    kategori: kategori,
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return LoadingPage();
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

  Future<void> init() async {
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
    await _firestore
        .collection("siswa")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      userMap["kecakapan"] = value.data()!["kecakapan"];
      userMap["agama"] = value.data()!["agama"];
    });
    setState(() {
      _isLoading = false;
    });
  }

  void onTap(int index) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _children[index]));
  }

  String check(String uid) {
    if (progress[uid] != null) {
      return progress[uid]["progress"];
    } else {
      return "belum";
    }
  }
}
