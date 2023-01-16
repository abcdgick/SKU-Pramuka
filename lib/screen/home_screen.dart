import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/extra/compass.dart';
import 'package:sku_pramuka/screen/list_tugas.dart';
import 'package:sku_pramuka/screen/pengumuman_screen.dart';
import 'package:sku_pramuka/screen/profile_screen.dart';
import 'package:sku_pramuka/screen/signin_screen.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';
import 'package:sku_pramuka/service/auth.dart';
import 'package:sku_pramuka/widgets/card_tugas.dart';

final List<Widget> _children = [
  HomePage(),
  ListTugas(),
  ProfilePage(
    isPembina: false,
  )
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  AuthClass authClass = AuthClass();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, String>> listPengumuman = [{}];
  List<Widget> imageSliders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: Border(
            bottom:
                BorderSide(color: Color.fromARGB(255, 78, 108, 80), width: 0)),
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(255, 78, 108, 80),
        title: Text(
          DateFormat("EEEE, d MMMM", "id_ID").format(DateTime.now()),
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
                if (_isLoading) init(snapshot.data!["sekolah"]);
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
      body: _isLoading
          ? const LoadingPage()
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0,
                                  color: Color.fromARGB(255, 78, 108, 80)),
                              color: Color.fromARGB(255, 78, 108, 80),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(300, 150)),
                            ),
                          ),
                          Positioned(
                              top: -10,
                              left: 10,
                              right: 10,
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10.0),
                                    height: 200.0,
                                    child: info(),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 30,
                      ),
                      child: Wrap(
                        runSpacing: 10,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: null,
                                color: Color.fromARGB(255, 78, 141, 82),
                                icon: Icon(
                                  Icons.inbox,
                                  size: 50,
                                  color: Color.fromARGB(255, 92, 170, 97),
                                ),
                                padding: EdgeInsets.only(bottom: 30),
                              ),
                              Text(
                                "Pancasila",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.invert_colors_off,
                                  color: Color.fromARGB(255, 92, 170, 97),
                                  size: 50,
                                ),
                                padding: EdgeInsets.only(bottom: 30),
                              ),
                              Text(
                                "Dasa Dharma",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KompasPage(),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.explore,
                                  color: Color.fromARGB(255, 92, 170, 97),
                                  size: 50,
                                ),
                                padding: EdgeInsets.only(bottom: 30),
                              ),
                              Text(
                                "Kompas",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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

  void init(String sekolah) async {
    await _firestore
        .collection("pengumuman")
        .where("sekolah", isEqualTo: sekolah)
        .orderBy("tipe", descending: false)
        .get()
        .then((value) {
      listPengumuman.clear();
      for (var doc in value.docs) {
        listPengumuman.add({
          "judul": doc["judul"],
          "detil": doc["detil"],
          "tipe": doc["tipe"],
          "foto": doc["foto"],
          "pembuat": doc["pembuat"],
          "tanggal": DateFormat("EEEE, d MMMM yyyy", "id_ID")
              .format(doc["tanggal"].toDate())
        });
      }
    });

    imageSliders = listPengumuman
        .map((item) => Container(
              margin: EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PengumumanPage(
                      judul: item["judul"]!,
                      detil: item["detil"]!,
                      foto: item["foto"]!,
                      pembuat: item["pembuat"]!,
                      tanggal: item["tanggal"]!,
                    ),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        item["foto"] == ""
                            ? Container(
                                //padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: ambilWarna(item["tipe"]!),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(checkIcon(item["tipe"]!),
                                      color: Colors.white, size: 70),
                                ),
                              )
                            : Image.network(item["foto"]!,
                                fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              item["judul"]!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();

    print(imageSliders);
    setState(() {
      _isLoading = false;
    });
  }

  void onTap(int index) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _children[index]));
  }

  Widget info() {
    return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 0,
            autoPlay: true),
        items: imageSliders);
    // return ListView.builder(
    //     itemCount: listPengumuman.length,
    //     scrollDirection: Axis.horizontal,
    //     itemBuilder: ((context, index) {
    //       return Center(
    //         child: Container(
    //           padding: EdgeInsets.symmetric(horizontal: 3),
    //           width: 300,
    //           height: 180,
    //           child: InkWell(
    //             onTap: () => Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => PengumumanPage(
    //                   judul: listPengumuman[index]["judul"]!,
    //                   detil: listPengumuman[index]["detil"]!,
    //                   foto: listPengumuman[index]["foto"] ?? "",
    //                   pembuat: listPengumuman[index]["pembuat"]!,
    //                   tanggal: listPengumuman[index]["tanggal"]!,
    //                 ),
    //               ),
    //             ),
    //             child: Card(
    //                 elevation: 7,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10.0),
    //                 ),
    //                 child: Container(
    //                   padding: const EdgeInsets.all(8.0),
    //                   decoration: BoxDecoration(
    //                     gradient: LinearGradient(
    //                       colors: ambilWarna(listPengumuman[index]["tipe"]!),
    //                     ),
    //                   ),
    //                   child: Row(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Icon(checkIcon(listPengumuman[index]["tipe"]!),
    //                           color: Colors.white, size: 70),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Flexible(
    //                         child:
    //                             Text(listPengumuman[index]["judul"] ?? "Test",
    //                                 style: TextStyle(
    //                                   fontFamily: 'Sono',
    //                                   color: Colors.white,
    //                                   fontSize: 20,
    //                                 )),
    //                       ),
    //                     ],
    //                   ),
    //                 )),
    //           ),
    //         ),
    //       );
    //     }));
  }

  IconData checkIcon(String tipe) {
    switch (tipe) {
      case "1":
        return Icons.warning_amber;
      case "2":
        return Icons.announcement_outlined;
      case "3":
        return Icons.info_outline;
      default:
        return Icons.info_outline;
    }
  }

  List<Color> ambilWarna(String tipe) {
    switch (tipe) {
      case "3":
        return [
          Color.fromARGB(255, 127, 164, 250),
          Color.fromARGB(255, 147, 184, 250),
        ];
      case "2":
        return [
          Color.fromARGB(255, 247, 211, 132),
          Color.fromARGB(255, 255, 225, 156),
        ];
      case "1":
        return [
          Color.fromARGB(255, 253, 125, 125),
          Color.fromARGB(255, 255, 145, 145),
        ];
      default:
        return [
          Color.fromARGB(255, 247, 211, 132),
          Color.fromARGB(255, 255, 225, 156),
        ];
    }
  }
}
