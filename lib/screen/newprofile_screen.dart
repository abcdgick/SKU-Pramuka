import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sku_pramuka/screen/home_screen.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';
import 'package:time_machine/time_machine.dart';

enum Pil { Laki, Perempuan }

class NewProfile extends StatefulWidget {
  final String name, email, pass;
  final bool logged;
  const NewProfile(
      {super.key,
      required this.name,
      required this.email,
      required this.pass,
      required this.logged});

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController tingkatt = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _passwordVisible = false;
  bool _isLoading = false;
  String? selectedSekolah;
  String? formattedDate;
  DateTime? tl;
  String tingkat = "None";
  int umur = -1;

  final lsiaga = <String>["Muda", "Bantu", "Tata"];
  final lpenggalang = <String>["Ramu", "Rakit", "Terap", "Garuda"];
  final lpenegak = <String>["Tamu", "Bantara", "Laksana"];

  Pil? _pil = Pil.Laki;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    name.text = widget.name;
    email.text = widget.email;
    password.text = widget.pass;
    tingkatt.text = tingkat;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingPage();
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text("Data Diri",
                style: TextStyle(color: Colors.white, fontSize: 24)),
            centerTitle: true,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    textFormBiasa(const Icon(Icons.person, color: Colors.grey),
                        "Nama", "Isikan nama anda", true, name),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormEmail(),
                    const SizedBox(
                      height: 20,
                    ),
                    textFormPass(),
                    const SizedBox(
                      height: 20,
                    ),
                    fieldDropDown(
                        const Icon(
                          Icons.school,
                          color: Colors.grey,
                        ),
                        "Asal Sekolah",
                        "Mohon pilih asal sekolah anda"),
                    const SizedBox(height: 20),
                    textFormTanggal(
                        const Icon(
                          Icons.event,
                          color: Colors.grey,
                        ),
                        "Tanggal Lahir",
                        "Mohon inputkan tanggal lahir anda",
                        dateInput),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          textFormBiasa(
                              const Icon(Icons.elderly, color: Colors.grey),
                              "Tingkat",
                              "Isikan tingkat anda",
                              false,
                              tingkatt),
                          const SizedBox(
                            width: 20,
                          ),
                          fieldDropDown2(
                              const Icon(Icons.info, color: Colors.grey),
                              "Kecakapan",
                              "Isikan kecakapan anda")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    radioBtnPil(),
                    const SizedBox(
                      height: 40,
                    ),
                    colorButton(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ));
    }
  }

  Widget textFormBiasa(Icon icon, String label, String empty, bool full,
      TextEditingController controller) {
    return SizedBox(
      width: full
          ? MediaQuery.of(context).size.width - 60
          : MediaQuery.of(context).size.width / 2 - 50,
      height: 60,
      child: TextFormField(
        readOnly: !full,
        cursorColor: Colors.white,
        onChanged: (value) => setState(() {}),
        style: const TextStyle(color: Colors.white, fontSize: 17),
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]+"))
        ],
        decoration: InputDecoration(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            prefixIcon: icon,
            suffixIcon: full
                ? (controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          controller.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear)))
                : null,
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15))),
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return empty;
          }
          return null;
        },
      ),
    );
  }

  Widget textFormEmail() {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 60,
      child: TextFormField(
        readOnly: widget.logged,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 17),
        keyboardType: TextInputType.emailAddress,
        //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(pattern))],
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            prefixIcon: const Icon(Icons.email, color: Colors.grey),
            suffixIcon: email.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      email.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.clear)),
            labelText: "Email",
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15))),
        controller: email,
        validator: (value) {
          if (value!.isEmpty) {
            return "Mohon Isikan Email Anda";
          } else if (!RegExp(pattern).hasMatch(value)) {
            return "Mohon Masukkan Email dengan Benar";
          }
          return null;
        },
      ),
    );
  }

  Widget textFormPass() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 60,
      child: TextFormField(
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 17),
        obscureText: !_passwordVisible,
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            labelText: "Password",
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => setState(() {
                _passwordVisible = !_passwordVisible;
              }),
            ),
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15))),
        controller: password,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Mohon Isikan Password Anda';
          }
          return null;
        },
      ),
    );
  }

  Widget fieldDropDown(Icon icon, String label, String empty) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 60,
      child: DropdownButtonFormField<String>(
        value: selectedSekolah,
        items: <String>['SD', 'SMP', 'SMA'].map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (sekolah) => setState(() {
          selectedSekolah = sekolah!;
        }),
        validator: (value) => value == null ? empty : null,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        dropdownColor: Colors.black87,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            prefixIcon: icon,
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white, fontSize: 17),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  Widget fieldDropDown2(Icon icon, String label, String empty) {
    List<String> list;
    if (umur < 7) {
      list = ["None"];
      tingkatt.text = "None";
    } else if (umur < 11) {
      list = lsiaga;
      tingkatt.text = "Siaga";
    } else if (umur < 16) {
      list = lpenggalang;
      tingkatt.text = "Penggalang";
    } else if (umur < 21) {
      list = lpenegak;
      tingkatt.text = "Penegak";
    } else {
      list = ["None"];
    }
    tingkat = list[0];
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 30,
      height: 60,
      child: DropdownButtonFormField<String>(
        value: tingkat,
        items: list.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) => setState(() {
          tingkat = value!;
        }),
        validator: (value) => value == null ? empty : null,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        dropdownColor: Colors.black87,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            prefixIcon: icon,
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white, fontSize: 17),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  Widget radioBtnPil() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio(
            value: Pil.Laki,
            groupValue: _pil,
            onChanged: (Pil? value) => setState(() {
              _pil = value;
            }),
            fillColor: MaterialStateColor.resolveWith((states) => Colors.amber),
          ),
          const Text("Laki-laki",
              style: TextStyle(color: Colors.white, fontSize: 17)),
          const SizedBox(
            width: 50,
          ),
          Radio(
            value: Pil.Perempuan,
            groupValue: _pil,
            onChanged: (Pil? value) => setState(() {
              _pil = value;
            }),
            fillColor: MaterialStateColor.resolveWith((states) => Colors.amber),
          ),
          const Text("Perempuan",
              style: TextStyle(color: Colors.white, fontSize: 17)),
        ],
      ),
    );
  }

  Widget textFormTanggal(
      Icon icon, String label, String empty, TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 60,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2017),
              firstDate: DateTime(2003),
              lastDate: DateTime(2017));
          if (pickedDate != null) {
            tl = pickedDate;
            formattedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
            LocalDate b = LocalDate.dateTime(DateTime.now());
            Period diff = b.periodSince(LocalDate.dateTime(pickedDate));
            setState(() {
              umur = diff.years;
              controller.text = formattedDate!;
            });
          }
        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            prefixIcon: icon,
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      controller.clear();
                      setState(() {
                        umur = -1;
                      });
                    },
                    icon: const Icon(Icons.clear)),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.amber,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15))),
        validator: (value) {
          if (value!.isEmpty) {
            return empty;
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });
          try {
            User? user;
            if (!widget.logged) {
              user = (await _auth.createUserWithEmailAndPassword(
                      email: email.text, password: password.text))
                  .user;
              user!.updateDisplayName(name.text);
            } else {
              user = null;
            }

            if (user != null || widget.logged) {
              String pil;
              if (_pil.toString() == "Pil.Laki") {
                pil = "Laki-Laki";
              } else {
                pil = "Perempuan";
              }
              await _firestore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .set({
                "uid": _auth.currentUser!.uid,
                "name": name.text,
                "email": email.text,
                "sekolah": selectedSekolah,
                "tl": tl,
                "umur": umur,
                "tingkat": tingkatt.text,
                "kecakapan": tingkat,
                "pembina": "",
                "gender": pil,
                "profile": ""
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Welcome ${name.text}!"),
                  backgroundColor: Colors.grey,
                ),
              );
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => HomePage(name: name.text)),
                  (route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Pembuatan Akun Gagal"),
                ),
              );
            }
            setState(() {
              _isLoading = false;
            });
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message!),
              ),
            );
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c)
          ]),
        ),
        child: const Center(
          child: Text(
            "Buat Akun",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
