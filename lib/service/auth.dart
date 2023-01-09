import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sku_pramuka/screen/home_screen.dart';
import 'package:sku_pramuka/screen/newprofile_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sku_pramuka/screen/signin_screen.dart';

class AuthClass {
  GoogleSignIn _googleSignIn = GoogleSignIn(
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
      String kecakapan) async {
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
        await _firestore.collection('siswa').doc(_auth.currentUser!.uid).set({
          "uid": _auth.currentUser!.uid,
          "name": name,
          "email": email,
          "sekolah": sekolah,
          "tl": tl,
          "umur": umur,
          "tingkat": tingkat,
          "kecakapan": kecakapan,
          "pembina": "",
          "gender": gender,
          "profile": ""
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome ${name}!"),
          ),
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => HomePage(name: name)),
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
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          storeCreds(userCredential);
          QuerySnapshot query = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userCredential.user!.email!)
              .get();
          if (query.docs.length != 0) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(name: userCredential.user!.displayName!)),
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

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(name: userCredential.user!.displayName!)),
          (route) => false);
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeCreds(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
    await storage.write(
        key: "name", value: userCredential.user!.displayName.toString());
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
