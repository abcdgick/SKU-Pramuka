import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PengumumanPage extends StatelessWidget {
  final String judul;
  final String detil;
  final String foto;
  final String pembuat;
  final String tanggal;
  final bool isPembina;
  const PengumumanPage(
      {super.key,
      required this.judul,
      required this.detil,
      required this.foto,
      required this.pembuat,
      required this.tanggal,
      required this.isPembina});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 78, 108, 80),
          title: Text("Pengumuman",
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
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "$pembuat - $tanggal",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  foto == ""
                      ? Container()
                      : Hero(
                          tag: "${judul}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.network(foto),
                          ),
                        ),
                  foto == ""
                      ? Container()
                      : SizedBox(
                          height: 20.0,
                        ),
                  Text(detil)
                ],
              ),
            ),
          ),
        ));
  }
}
