import 'package:adminproject/booking_provider.dart';
import 'package:adminproject/edit.dart';
import 'package:adminproject/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyAJ_ltekoautAP-i0zpBL8J5o7qaRzYQ54",
    appId: "1:802992401132:android:1130b05b077682bb0653c9",
    messagingSenderId: "802992401132",
    projectId: "progect-80cea",
    storageBucket: "progect-80cea.appspot.com",
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        routes: {
          'UPDATE': (context) => edit(),
        },
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    ),
  );
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool finalEmail = false;

  Future getuserdata() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getBool('islogged');
    setState(() {
      finalEmail = obtainedEmail!;
    });
  }

  @override
  void initState() {
    getuserdata().whenComplete(() {
      if (finalEmail == false) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => admin(),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => home(),
            ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return home();
  }
}

class admin extends StatefulWidget {
  const admin({super.key});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  TextEditingController id = TextEditingController();
  TextEditingController pass = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    login() async {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: id.text, password: pass.text);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => home(),
            ));
        print("login Successful");
      } catch (e) {
        print("error$e");
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/images/download (2).jpg"),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              SizedBox(
                height: 350,
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: TextField(
                  controller: id,
                  decoration: InputDecoration(
                    labelText: "ID",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: TextField(
                  controller: pass,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setBool("islogged", true);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => home(),
                    //     ));
                    login();
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
