import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/extra/buat_pengumuman.dart';
import 'package:sku_pramuka/screen/extra/compass.dart';
import 'package:sku_pramuka/screen/extra/list_pembina.dart';
import 'package:sku_pramuka/screen/extra/list_siswa.dart';
import 'package:sku_pramuka/screen/extra/pramuka_icons.dart';
import 'package:sku_pramuka/screen/extra/teks.dart';
import 'package:sku_pramuka/screen/list_tugas.dart';
import 'package:sku_pramuka/screen/pengumuman_screen.dart';
import 'package:sku_pramuka/screen/profile_screen.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';
import 'package:sku_pramuka/service/auth.dart';

int index = 0;

final List<Widget> _children = [
  HomePage(i: index),
  ListTugas(i: index),
  ProfilePage(
    isPembina: false,
    i: index,
  )
];

class HomePage extends StatefulWidget {
  final int i;
  const HomePage({super.key, required this.i});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String db = "siswa";
  int? jumlahPending;
  bool _isLoading = true;
  AuthClass authClass = AuthClass();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, String>> listPengumuman = [{}];
  List<Widget> imageSliders = [];
  Map<String, dynamic>? listSiswa;
  Map<String, dynamic>? listPembina;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.i > 0) {
      index = widget.i;
      switch (widget.i) {
        case 1:
          db = "pembina";
          break;
        case 2:
          db = "admin";
          break;
        default:
          db = "siswa";
          break;
      }
    }
    setState(() {
      listPengumuman.clear();
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
                .collection(db)
                .doc(_auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (_isLoading) {
                  switch (widget.i) {
                    case 0:
                      init(snapshot.data!["sekolah"])
                          .then((value) => initCarousel());
                      break;
                    case 1:
                      List<String> listSekolah =
                          (snapshot.data!["sekolah"] as List)
                              .map((item) => item as String)
                              .toList();
                      wrapInit(listSekolah).then((value) => initCarousel());
                      break;
                    case 2:
                      initAdmin();
                      break;
                    default:
                  }
                }
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
              } else {
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
              }
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
                                    child: widget.i == 2 ? infoAdmin() : info(),
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
                      child: widget.i == 0
                          ? SiswaWidget(context)
                          : widget.i == 1
                              ? PembinaWidget(context)
                              : AdminWidget(context),
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

  Wrap SiswaWidget(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeksPage(
                index: 0,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Pramuka.pancasila,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
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
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeksPage(
                index: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
              ),
              Text(
                "Trisatya",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeksPage(
                index: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
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
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KompasPage(),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.explore,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
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
        ),
      ],
    );
  }

  Wrap PembinaWidget(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListSiswa(
                isAdmin: false,
                siswaBaru: false,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.groups,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
              ),
              Text(
                "Daftar Siswa",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuatPengumuman(),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.campaign,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
              ),
              Text(
                "Buat Pengumuman",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KompasPage(),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.explore,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
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
        ),
      ],
    );
  }

  Wrap AdminWidget(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      children: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListSiswa(
                isAdmin: true,
                siswaBaru: false,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.groups,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
              ),
              Text(
                "Daftar Siswa",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListPembina(),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
              ),
              Text(
                "Daftar Pembina",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 30),
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KompasPage(),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.explore,
                color: Color.fromARGB(255, 92, 170, 97),
                size: 50,
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
        ),
      ],
    );
  }

  Future<void> wrapInit(List<String> listSekolah) async {
    for (String sekolah in listSekolah) {
      await init(sekolah);
    }
  }

  Future<void> init(String sekolah) async {
    await _firestore
        .collection("pengumuman")
        .where("sekolah", isEqualTo: sekolah)
        .orderBy("tipe", descending: false)
        .get()
        .then((value) {
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
  }

  void initCarousel() {
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
                      isPembina: (widget.i == 2),
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

    setState(() {
      _isLoading = false;
    });
  }

  void initAdmin() async {
    await _firestore
        .collection("admin")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      listSiswa = {};
      List<String> tmpSiswa = (value.data()!["siswabaru"] as List)
          .map((item) => item as String)
          .toList();

      for (var siswa in tmpSiswa) {
        _firestore
            .collection("siswa")
            .doc(siswa)
            .get()
            .then((value) => listSiswa![siswa] = value.data());
      }
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
  }

  Widget infoAdmin() {
    return ListView.builder(
        itemCount: 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          return Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3),
              width: 300,
              height: 180,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListSiswa(
                            isAdmin: true,
                            siswaBaru: true,
                          )),
                ),
                child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 127, 164, 250),
                            Color.fromARGB(255, 147, 184, 250)
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.white, size: 70),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                                "Terdapat ${listSiswa!.length} siswa baru yang perlu diverifikasi datanya",
                                style: TextStyle(
                                  fontFamily: 'Sono',
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          );
        }));
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
