import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sku_pramuka/screen/list_tugas.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';
import 'package:uuid/uuid.dart';

class TugasPage extends StatefulWidget {
  final String uid;
  final String title;
  final String progress;
  final List<String> kategori;
  const TugasPage(
      {super.key,
      required this.uid,
      required this.title,
      required this.progress,
      required this.kategori});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  String inet = "";
  File? file;
  bool isFoto = false;
  bool proses = false;
  bool _isLoading = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController isiText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.kategori.contains("outdoor") ? isFoto = true : null;
    init(widget.progress);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingPage()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 78, 108, 80),
              title: Text("Tugas",
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              centerTitle: true,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 240, 235, 206),
                    Color.fromARGB(255, 250, 245, 216),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          label("Status"),
                          SizedBox(height: 12),
                          chipData(
                            widget.progress.toUpperCase(),
                            check(widget.progress),
                          ),
                          SizedBox(height: 25),
                          label("Kategori"),
                          SizedBox(height: 12),
                          Wrap(
                            runSpacing: 10,
                            children: [
                              chipData("Menyanyi", 0xffff6d6e),
                              SizedBox(width: 20),
                              chipData("Gotong Royong", 0xfff29732),
                              SizedBox(width: 20),
                              chipData("Menulis", 0xff6557ff),
                              SizedBox(width: 20),
                              chipData("Outdoor", 0xff234ebd),
                              SizedBox(width: 20),
                              chipData("Entah", 0xff2bc8d9),
                            ],
                          ),
                          SizedBox(height: 25),
                          isFoto
                              ? label("Foto Pengerjaan")
                              : label("Text Jawaban"),
                          SizedBox(height: 15),
                          isFoto ? foto() : text(),
                          SizedBox(height: 40),
                          !proses ? button() : Container(),
                          !proses ? SizedBox(height: 20) : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget title() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Nama Tugas",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget text() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        enabled: !proses,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        controller: isiText,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Deskripsi Tugas",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget foto() {
    return file != null || proses
        ? Center(
            child: proses
                ? Image.network(
                    inet,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    file!,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
          )
        : Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                final source = await showImageSource(context);

                if (source == null) return;
                pickImage(source);
              },
              child: const Text('Ambil Gambar'),
            ),
          );
  }

  Future<ImageSource?> showImageSource(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: ((context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Gallery"),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          )),
    );
  }

  Future<bool> pickImage(ImageSource source) async {
    try {
      await ImagePicker().pickImage(source: source).then((value) async {
        if (value != null) {
          setState(() {
            file = File(value.path);
          });
        }
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil gambar: $e"),
        ),
      );
    }
    return false;
  }

  Widget chipData(String label, int color) {
    return Chip(
      backgroundColor: Color(color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        String fileName = Uuid().v1();
        String key = "";
        String value = "";

        if (isFoto) {
          var ref = FirebaseStorage.instance
              .ref()
              .child('tugas')
              .child("$fileName.jpg");
          var uploadTask = await ref.putFile(file!);
          key = "gambar";
          value = await ref.getDownloadURL();
        } else if (isiText.text.isNotEmpty) {
          key = "teks";
          value = isiText.text;
        } else {
          return;
        }

        await _firestore
            .collection("siswa")
            .doc(_auth.currentUser!.uid)
            .collection("progress")
            .doc()
            .set({
          "pembina": "Ys95RAzEFh7uIkmPyjwp",
          "progress": "proses",
          "tanggal": DateTime.now(),
          "tugas": widget.uid,
          key: value
        }).then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ListTugas()),
                ModalRoute.withName('/')));
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Color(0xff8a32f1),
              Color(0xffad32f9),
            ],
          ),
        ),
        child: Center(
          child: Text(
            "Submit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void init(String progress) async {
    if (progress == "proses" || progress == "diterima") {
      setState(() {
        _isLoading = true;
      });
      proses = true;
      await _firestore
          .collection("siswa")
          .doc(_auth.currentUser!.uid)
          .collection("progress")
          .where("tugas", isEqualTo: widget.uid)
          .get()
          .then((value) {
        if (isFoto)
          inet = value.docs[0].data()["gambar"];
        else
          isiText.text = value.docs[0].data()["teks"].toString();
      });
      setState(() {
        _isLoading = false;
      });
    } else {
      proses = false;
    }
  }

  int check(String progress) {
    switch (progress) {
      case "belum":
        return 0xff2bc8d9;
      case "proses":
        return 0xff2664fa;
      case "ditolak":
        return 0xFFFF6464;
      case "diterima":
        return 0xffB3FFAE;
      default:
        return 0xFF000000;
    }
  }
}
