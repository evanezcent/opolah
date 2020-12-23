import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:opolah/ui/screens/login/login_screen.dart';
import 'package:opolah/ui/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Barlow'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool available;

  void getActiveUser() async {
    var prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("userID");

    if (id != null) {
      setState(() {
        available = true;
      });
    } else {
      setState(() {
        available = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getActiveUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomSplash(
          imagePath: 'assets/images/logo.png',
          home: available ? MainScreen() : LoginScreen(),
          animationEffect: 'zoom-in',
          duration: 2500,
          type: CustomSplashType.StaticDuration,
        ));
  }
}
