import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sku_pramuka/screen/admin/list_pembina.dart';
import 'package:sku_pramuka/screen/admin/list_sekolah.dart';
import 'package:sku_pramuka/screen/admin/settings.dart';
import 'package:sku_pramuka/screen/extra/list_siswa.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<Map<String, String>> listPengumuman = [{}];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? listSiswa;
  List<Widget> imageSliders = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    initBaru();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          shape: const Border(
              bottom: BorderSide(
                  color: Color.fromARGB(255, 78, 108, 80), width: 0)),
          elevation: 0,
          toolbarHeight: 70,
          backgroundColor: const Color.fromARGB(255, 78, 108, 80),
          title: Text(
            DateFormat("EEEE, d MMMM", "id_ID").format(DateTime.now()),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
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
                                  color:
                                      const Color.fromARGB(255, 78, 108, 80)),
                              color: const Color.fromARGB(255, 78, 108, 80),
                              borderRadius: const BorderRadius.only(
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
                                    child: infoBaru(),
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
                        runSpacing: 30,
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListSekolah(),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.school,
                                  color: Color.fromARGB(255, 92, 170, 97),
                                  size: 50,
                                ),
                                Text(
                                  "Daftar Sekolah",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListPembina(),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.supervisor_account,
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
        selectedItemColor: const Color.fromARGB(255, 78, 108, 80),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.indigoAccent,
                    Colors.purple,
                  ],
                ),
              ),
              child: const Icon(
                Icons.task,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: "Tugas",
          ),
          const BottomNavigationBarItem(
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

  Future<void> initBaru() async {
    listPengumuman.clear();
    await _firestore
        .collection("siswa")
        .where("baru", isEqualTo: true)
        .get()
        .then((value) {
      listPengumuman
          .add({"judul": "Terdapat ${value.size} siswa baru", "tipe": "2"});
      print(listPengumuman);
      initCarousel();
    });
  }

  void onTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeAdmin(),
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ListSekolah(),
        ));
        break;
      case 2:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Pengaturan(),
        ));
        break;
      default:
    }
  }

  Widget infoBaru() {
    return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 0,
            autoPlay: true),
        items: imageSliders);
  }

  void initCarousel() {
    imageSliders = listPengumuman
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: InkWell(
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Container(
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
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              item["judul"]!,
                              style: const TextStyle(
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
          const Color.fromARGB(255, 127, 164, 250),
          const Color.fromARGB(255, 147, 184, 250),
        ];
      case "2":
        return [
          const Color.fromARGB(255, 247, 211, 132),
          const Color.fromARGB(255, 255, 225, 156),
        ];
      case "1":
        return [
          const Color.fromARGB(255, 253, 125, 125),
          const Color.fromARGB(255, 255, 145, 145),
        ];
      default:
        return [
          const Color.fromARGB(255, 247, 211, 132),
          const Color.fromARGB(255, 255, 225, 156),
        ];
    }
  }
}
