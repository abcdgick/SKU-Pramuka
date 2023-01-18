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

final List<Widget> _children = [
  HomePage(),
  ListTugas(),
  ProfilePage(
    isPembina: false,
  )
];

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
  Map<String, String> pembina = {};
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
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 78, 108, 80),
        title: Text(
          "SKU",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          StreamBuilder(
            stream: _firestore
                .collection("siswa")
                .doc(_auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(28),
                        child: Image.network(
                          snapshot.data!["profile"],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                );
              } else
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                );
            },
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
                    uid: map["uid"],
                    title: map["nama"],
                    iconData: map['kategori'].contains("outdoor")
                        ? Icons.hiking
                        : Icons.edit,
                    iconColor: map['kategori'].contains("outdoor")
                        ? Colors.white
                        : Color(0xFF395144),
                    iconBgColor: map['kategori'].contains("outdoor")
                        ? Color(0xff00B8A9)
                        : Colors.white,
                    check: check(map["uid"]),
                    kategori: kategori,
                    pembina: pembina,
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
        .get()
        .then((value) {
      userMap["kecakapan"] = value.data()!["kecakapan"];
      userMap["agama"] = value.data()!["agama"];
    });
    init2().then((value) => setState((() {
          _isLoading = false;
        })));
  }

  Future<void> init2() async {
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
    init3();
  }

  Future<void> init3() async {
    await _firestore
        .collection("pembina")
        .where("siswa", arrayContains: _auth.currentUser!.uid)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        pembina[doc.data()["uid"].toString()] = doc.data()["nama"].toString();
      }
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
