import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TugasPage extends StatefulWidget {
  final String title;
  final String progress;
  final List<String> kategori;
  const TugasPage(
      {super.key,
      required this.title,
      required this.progress,
      required this.kategori});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                        widget.progress.toUpperCase(), check(widget.progress)),
                    SizedBox(height: 25),
                    label("Tanggal Pengerjaan"),
                    SizedBox(height: 12),
                    tanggal(),
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
                    SizedBox(height: 40),
                    button(),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          )),
        ));
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

  Widget tanggal() {
    return Container(
      height: 150,
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
    return Container(
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
    );
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
