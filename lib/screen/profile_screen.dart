import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/home_screen.dart';
import 'package:sku_pramuka/screen/list_tugas.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';
import 'package:sku_pramuka/service/auth.dart';
import 'package:uuid/uuid.dart';

int index = 0;
var tag = "dis";

final List<Widget> _children = [
  HomePage(i: index),
  ListTugas(i: index),
  ProfilePage(
    isPembina: false,
    i: index,
  )
];

class ProfilePage extends StatefulWidget {
  final int i;
  final bool isPembina;
  const ProfilePage({super.key, required this.isPembina, required this.i});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic>? userMap;
  AuthClass authClass = AuthClass();
  String db = "siswa";
  String kota = "";
  String kecamatan = "";
  String sekolah = "";
  String gudep = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch (widget.i) {
      case 0:
        init();
        break;
      case 1:
        db = "pembina";
        initPembina();
        break;
      case 2:
        db = "admin";
        break;
      default:
    }
    index = widget.i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(255, 78, 108, 80),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authClass.signOut(context);
              authClass.signOutGoogle(context: context);
            },
            color: Colors.redAccent,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingPage()
          : StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection(db)
                  .doc(_auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              tag = snapshot.data!["profile"];
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SaveImage(
                                    imageUrl: snapshot.data!['profile'],
                                    tag: tag,
                                    collection: db,
                                    doc: _auth.currentUser!.uid,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: snapshot.data!['profile'],
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(120),
                                  child: Image.network(
                                      snapshot.data!['profile'],
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          tile(
                            const Icon(Icons.person),
                            "Name",
                            snapshot.data!['name'],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          tile(
                            const Icon(Icons.email),
                            "Email",
                            snapshot.data!['email'],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          widget.i == 0
                              ? siswaWidget(snapshot)
                              : lainWidget(snapshot),
                        ],
                      ),
                    ),
                  );
                } else {
                  return LoadingPage();
                }
              }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: onTap,
        currentIndex: 2,
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

  Column siswaWidget(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    return Column(
      children: [
        tile(
          const Icon(Icons.event),
          "Tanggal Lahir",
          DateFormat("d MMMM yyyy", "id_ID")
              .format((snapshot.data!['tl'] as Timestamp).toDate()),
        ),
        const SizedBox(
          height: 20,
        ),
        tile(
          const Icon(Icons.elderly),
          "Tingkat",
          snapshot.data!['tingkat'],
        ),
        const SizedBox(
          height: 20,
        ),
        tile(
          const Icon(Icons.info),
          "Kecakapan",
          snapshot.data!['kecakapan'],
        ),
        const SizedBox(
          height: 20,
        ),
        tile(
          const Icon(Icons.school),
          "Sekolah",
          sekolah,
        ),
        const SizedBox(
          height: 20,
        ),
        tile(
          const Icon(Icons.numbers),
          "Nomor Gudep",
          gudep,
        ),
        const SizedBox(
          height: 20,
        ),
        tile(
          const Icon(Icons.location_on),
          "Kecamatan",
          kecamatan,
        ),
        const SizedBox(
          height: 20,
        ),
        tile(
          const Icon(Icons.location_city),
          "Kota",
          kota,
        ),
      ],
    );
  }

  Column lainWidget(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    return Column(
      children: [
        widget.i == 1
            ? tile(const Icon(Icons.school), "Sekolah", sekolah)
            : Container(),
        widget.i == 1 ? const SizedBox(height: 20) : Container(),
        tile(
          const Icon(Icons.location_on),
          "Kecamatan",
          snapshot.data!["kecamatan"],
        ),
        const SizedBox(
          height: 20,
        ),
        tile(
          const Icon(Icons.location_city),
          "Kota",
          snapshot.data!["kota"],
        ),
      ],
    );
  }

  void onTap(int index) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _children[index]));
  }

  void init() async {
    setState(() {
      _isLoading = true;
    });

    await _firestore
        .collection("siswa")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      userMap = value.data();
      tag = userMap!['profile'];
    });

    await _firestore
        .collection("sekolah")
        .doc(userMap!["sekolah"])
        .get()
        .then((value) {
      kota = value.data()!["kota"];
      kecamatan = value.data()!["kecamatan"];
      sekolah = value.data()!["nama"];

      if (userMap!["gender"] == "Laki-laki") {
        gudep = value.data()!["gudep putra"];
      } else {
        gudep = value.data()!["gudep putri"];
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  void initPembina() async {
    List<String> tmp = [];

    _firestore
        .collection("pembina")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) async {
      tmp = (value.data()!["sekolah"] as List)
          .map((item) => item as String)
          .toList();
      sekolah = "";
      for (var s in tmp) {
        await _firestore.collection("sekolah").doc(s).get().then(
            (value) => sekolah = "$sekolah•   ${value.data()!['nama']}\n");
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  void save(String dis) async {
    await _firestore
        .collection(db)
        .doc(_auth.currentUser!.uid)
        .update({dis.toLowerCase(): textEditingController.text});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$dis updated successfully')));
  }

  Widget tile(Icon dis, String title, String subs) {
    return ListTile(
      leading: dis,
      title: Text(title,
          style: const TextStyle(color: Colors.black, fontSize: 15)),
      subtitle: Text(subs,
          style: const TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
      trailing: widget.i > 0 && title != "Email"
          ? IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onPressed: () {
                textEditingController.text = subs;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Edit $title anda"),
                    content: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(hintText: "$title Anda"),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("BATAL"),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (textEditingController.text != subs &&
                                textEditingController.text != "") save(title);
                          },
                          child: const Text("SIMPAN"))
                    ],
                  ),
                );
              },
            )
          : SizedBox(),
    );
  }

  Widget daftarSekolah(List<String> texts) {
    var widgetList = <Widget>[];
    widgetList.add(
      const Text("Daftar Sekolah",
          style: TextStyle(color: Colors.black, fontSize: 15)),
    );
    widgetList.add(SizedBox(height: 10));
    for (var text in texts) {
      widgetList.add(unorderedListItem(text));
      widgetList.add(SizedBox(
        height: 5,
      ));
    }

    return Column(children: widgetList);
  }

  Widget unorderedListItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• "),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<void> ambilSekolah(List<String> listSekolah) async {}
}

class SaveImage extends StatelessWidget {
  final String imageUrl, collection, doc;
  final tag;

  SaveImage(
      {required this.imageUrl,
      required this.tag,
      Key? key,
      required this.collection,
      required this.doc})
      : super(key: key);

  File? imageFile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              if (await takeImage(context)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gambar Profile Berhasil Diubah"),
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.image_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              if (await pickImage(context)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gambar Profile Berhasil Diubah"),
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Hero(
        tag: tag,
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.black,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }

  Future<bool> pickImage(BuildContext context) async {
    try {
      await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80)
          .then((value) async {
        if (value != null) {
          imageFile = File(value.path);
          return uploadImage();
        }
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil gambar dari galeri: $e"),
        ),
      );
    }
    return false;
  }

  Future<bool> takeImage(BuildContext context) async {
    try {
      await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80)
          .then((value) async {
        if (value != null) {
          imageFile = File(value.path);
          return uploadImage();
        }
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil gambar dari kamera: $e"),
        ),
      );
    }
    return false;
  }

  Future<bool> uploadImage() async {
    String fileName = Uuid().v1();

    var ref =
        FirebaseStorage.instance.ref().child('profiles').child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!).then((p0) async {
      String imageUrl = await ref.getDownloadURL();
      await _firestore
          .collection(collection)
          .doc(doc)
          .update({"profile": imageUrl}).then((value) {
        return true;
      });
    });
    return false;
  }
}
