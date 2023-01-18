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
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/list_tugas.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';
import 'package:uuid/uuid.dart';

class TugasPage extends StatefulWidget {
  final String uid;
  final String title;
  final String progress;
  final List<String> kategori;
  final Map<String, String> pembina;
  const TugasPage(
      {super.key,
      required this.uid,
      required this.title,
      required this.progress,
      required this.kategori,
      required this.pembina});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  String inet = "";
  String? pembina;
  List<String>? listPembina;
  File? file;
  bool isFoto = false;
  bool proses = false;
  bool _isLoading = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController isiText = TextEditingController();
  String? pengerjaan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.kategori.contains("outdoor") ? isFoto = true : null;
    init(widget.progress, widget.pembina);
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
                          proses ? label("Dikerjakan pada") : Container(),
                          proses ? SizedBox(height: 12) : Container(),
                          proses ? dilaksanakan() : Container(),
                          proses ? SizedBox(height: 25) : Container(),
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
                          !proses ? SizedBox(height: 25) : Container(),
                          !proses ? label("Pembina") : Container(),
                          !proses ? SizedBox(height: 12) : Container(),
                          !proses ? cariPembina() : Container(),
                          !proses ? SizedBox(height: 40) : Container(),
                          !proses ? button() : Container(),
                          SizedBox(height: 20),
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

  Widget cariPembina() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: DropdownButtonFormField<String>(
        value: pembina,
        items: listPembina!.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
          setState(() {
            pembina = value;
          });
        },
        validator: (value) => value == null ? "Mohon isikan pembina" : null,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            prefixIcon: const Icon(
              Icons.hiking,
              color: Colors.grey,
            ),
            labelText: "Pembina",
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.deepOrange,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15))),
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
        try {
          String fileName = Uuid().v1();
          String key = "";
          String value = "";

          String uid = widget.pembina.keys
              .firstWhere((k) => widget.pembina[k] == pembina);

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
              .collection("pembina")
              .doc(uid)
              .collection("pending")
              .doc()
              .set({
            "siswa": _auth.currentUser!.uid,
            "tanggal": FieldValue.serverTimestamp(),
            "tugas": widget.uid,
            key: value
          });

          await _firestore
              .collection("siswa")
              .doc(_auth.currentUser!.uid)
              .collection("progress")
              .doc()
              .set({
            "pembina": uid,
            "progress": "proses",
            "tanggal": FieldValue.serverTimestamp(),
            "tugas": widget.uid,
            key: value
          }).then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const ListTugas()),
                  ModalRoute.withName('/')));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Kerjakan tugasnya dengan benar ya"),
            ),
          );
        }
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

  Widget dilaksanakan() {
    return Text(
      "$pengerjaan - $pembina",
      style: TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
    ;
  }

  void init(String progress, Map<String, String> pembina) async {
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
          .then((value) async {
        if (isFoto)
          inet = value.docs[0].data()["gambar"];
        else
          isiText.text = value.docs[0].data()["teks"].toString();

        pengerjaan = DateFormat("EEEE, d MMMM yyyy", "id_ID")
            .format(value.docs[0].data()['tanggal'].toDate());

        await _firestore
            .collection("pembina")
            .doc(value.docs[0].data()["pembina"])
            .get()
            .then((value2) => this.pembina = value2.data()!["nama"]);
      });
      setState(() {
        _isLoading = false;
      });
    } else {
      listPembina = [];
      pembina.forEach((key, value) {
        listPembina!.add(value);
      });
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
        return 0xff3C6255;
      default:
        return 0xFF000000;
    }
  }
}
