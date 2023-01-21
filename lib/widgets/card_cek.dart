import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sku_pramuka/screen/review_tugas.dart';
import 'package:sku_pramuka/screen/tugas_screen.dart';
import 'package:sku_pramuka/widgets/custom_checkbox.dart';

class CardCek extends StatelessWidget {
  final int no;
  final int i;
  final String uid;
  final Map<String, dynamic> siswa;
  final Map<String, dynamic> tugas;
  final String sekolah;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final List<String> kategori;

  CardCek(
      {super.key,
      required this.no,
      required this.i,
      required this.uid,
      required this.siswa,
      required this.tugas,
      required this.sekolah,
      required this.iconData,
      required this.iconColor,
      required this.iconBgColor,
      required this.kategori});

  Color checkColor = Color.fromARGB(255, 170, 139, 86);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TugasPage(
                    no: no,
                    i: i,
                    uid: tugas["uid"],
                    title: tugas["nama"],
                    progress: "proses",
                    kategori: kategori,
                    pembina: const {},
                    uidPending: uid,
                    uidSiswa: siswa["uid"],
                    namaSiswa: siswa["name"],
                    sekolah: sekolah,
                  ),
                ),
              ),
              child: SizedBox(
                height: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  //color: Color.fromARGB(255, 247, 211, 132),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 247, 211, 132),
                          Color.fromARGB(255, 255, 225, 156)
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Row(
                        children: [
                          Container(
                              height: 30,
                              width: 33,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                  child: Text(
                                no.toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ))),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${siswa['name']} - $sekolah",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.fade)),
                              SizedBox(
                                height: 5,
                              ),
                              Flexible(
                                child: Text(tugas["nama"],
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 15),
                                    overflow: TextOverflow.fade),
                              ),
                            ],
                          )),
                          Container(
                            height: 33,
                            width: 36,
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              iconData,
                              color: iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
