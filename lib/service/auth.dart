import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sku_pramuka/screen/home_screen.dart';
import 'package:sku_pramuka/screen/newprofile_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sku_pramuka/screen/signin_screen.dart';

class AuthClass {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = new FlutterSecureStorage();

  Future<void> emailSignUp(
      BuildContext context,
      bool logged,
      String name,
      String email,
      String password,
      String gender,
      String sekolah,
      DateTime tl,
      int umur,
      String tingkat,
      String kecakapan,
      String agama,
      String kecamatan) async {
    try {
      User? user;
      if (!logged) {
        user = (await _auth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;
        user!.updateDisplayName(name);
      } else {
        user = null;
      }

      if (user != null || logged) {
        String profile = "";
        switch (gender) {
          case "Laki-Laki":
            if (umur > 15)
              profile =
                  "https://firebasestorage.googleapis.com/v0/b/flutter-sku.appspot.com/o/profiles%2FDewasa%20Laki.png?alt=media&token=3858a66d-e588-4650-af33-b1cc10ac64a2";
            else
              profile =
                  "https://firebasestorage.googleapis.com/v0/b/flutter-sku.appspot.com/o/profiles%2FBocah%20Laki.png?alt=media&token=15c3167f-3a44-4aea-9d06-76600a13df88";
            break;
          case "Perempuan":
            if (umur > 15)
              profile =
                  "https://firebasestorage.googleapis.com/v0/b/flutter-sku.appspot.com/o/profiles%2FDewasa%20Perempuan.png?alt=media&token=e271caef-09bd-48ad-bd56-8c0563493c0e";
            else
              profile =
                  "https://firebasestorage.googleapis.com/v0/b/flutter-sku.appspot.com/o/profiles%2FBocah%20Perempuan.png?alt=media&token=8dfc2f7d-7d4b-4a51-b97d-31b2927597e3";
            break;
          default:
        }
        await _firestore.collection('siswa').doc(_auth.currentUser!.uid).set({
          "uid": _auth.currentUser!.uid,
          "name": name,
          "email": email,
          "sekolah": sekolah,
          "tl": tl,
          "umur": umur,
          "tingkat": tingkat,
          "kecakapan": kecakapan,
          "gender": gender,
          "profile": profile,
          "agama": agama
        });

        await _firestore
            .collection("pembina")
            .where("sekolah", arrayContains: sekolah)
            .get()
            .then((value) {
          for (var doc in value.docs)
            doc.reference.update({
              "siswa": FieldValue.arrayUnion([_auth.currentUser!.uid])
            });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome ${name}!"),
          ),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => HomePage(
                      i: 0,
                    )),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pembuatan Akun Gagal"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        try {
          int i = 0;
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          storeCreds(userCredential, i);
          QuerySnapshot query = await FirebaseFirestore.instance
              .collection('siswa')
              .where('email', isEqualTo: userCredential.user!.email!)
              .get();

          if (query.docs.length == 0) {
            i = 1;
            query = await FirebaseFirestore.instance
                .collection('pembina')
                .where('email', isEqualTo: userCredential.user!.email!)
                .get();
          }

          if (query.docs.length == 0) {
            i = 2;
            query = await FirebaseFirestore.instance
                .collection('admin')
                .where('email', isEqualTo: userCredential.user!.email!)
                .get();
          }

          if (query.docs.length != 0) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          i: i,
                        )),
                (route) => false);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewProfile(
                        name: userCredential.user!.displayName!,
                        email: userCredential.user!.email!,
                        pass: "",
                        logged: true)));
          }
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        final snackbar =
            SnackBar(content: Text("Gagal Masuk Menggunakan Akun Google"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> emailSignIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      int i = 0;
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('siswa')
          .where('email', isEqualTo: userCredential.user!.email!)
          .get();

      if (query.docs.isEmpty) {
        i = 1;
        query = await FirebaseFirestore.instance
            .collection('pembina')
            .where('email', isEqualTo: userCredential.user!.email!)
            .get();
      }

      if (query.docs.isEmpty) {
        i = 2;
        query = await FirebaseFirestore.instance
            .collection('admin')
            .where('email', isEqualTo: userCredential.user!.email!)
            .get();
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    i: i,
                  )),
          (route) => false);
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeCreds(UserCredential userCredential, int i) async {
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
    await storage.write(
        key: "name", value: userCredential.user!.displayName.toString());
    await storage.write(key: "i", value: i.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<String?> getUserCreds() async {
    return await storage.read(key: "userCredential");
  }

  Future<String?> getName() async {
    return await storage.read(key: "name");
  }

  Future<String?> getI() async {
    return await storage.read(key: "i");
  }

  Future<void> signOut(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datang Kembali!'),
        ),
      );
      await _auth.signOut().then((value) => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const SignIn()))));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  Future<void> signOutGoogle({required BuildContext context}) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
