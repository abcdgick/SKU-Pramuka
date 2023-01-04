import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sku_pramuka/screen/home_screen.dart';
import 'package:sku_pramuka/screen/signin_screen.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingPage();
    } else {
      return Scaffold(
          body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              googleButton(
                  "assets/image/google.svg", "Masuk dengan Google", 25),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Atau",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              textFormEmail(),
              const SizedBox(
                height: 20,
              ),
              textFormPass(),
              const SizedBox(
                height: 40,
              ),
              colorButton(),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Belum Punya Akun? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => const SignUp()),
                        (route) => false);
                  },
                  child: const Text(
                    "Buat Akun",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Lupa Password?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ));
    }
  }

  Widget googleButton(String img, String name, double size) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(width: 1, color: Colors.grey)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(
              img,
              height: size,
              width: size,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ]),
        ));
  }

  Widget textFormEmail() {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: 55,
      child: TextFormField(
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
      height: 55,
      child: TextFormField(
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 17),
        obscureText: !_passwordVisible,
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
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

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        try {
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
                  email: email.text, password: password.text);
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage(name: userCredential.user!.displayName!)),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c)
          ]),
        ),
        child: const Center(
          child: Text(
            "Sign In",
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
