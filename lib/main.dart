
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user.dart';
import 'login.dart';

String boxName = 'userBox';
String Nameuser='';
bool Darkmode =true ;
Color Background =  Color(0xFF131313) ;
Color fontcollor =Colors.white;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  await Hive.openBox<UserModel>(boxName);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas UAS TPM ',
      theme: ThemeData(
        primaryColor: Background, // Atur warna utama sesuai dengan Background yang Anda gunakan
        scaffoldBackgroundColor: Background,

      ),
      home: SplashScreen(isLoggedIn: isLoggedIn),
    );

  }
}

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({Key? key, required this.isLoggedIn }) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.isLoggedIn ? BottomNavbar() : const LoginPage(),),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ANIVERSE',
              style: TextStyle(
                  fontSize: 80,
                  color: fontcollor,
                  fontFamily: "Bangers"
              ),
            ),
            Container(
              width: 150,
              height: 150,
              child: Image.asset("assets/splash.png"),
            )
          ],
        )
      ),
    );
  }
}
