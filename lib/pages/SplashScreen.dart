import 'dart:async';
import 'package:flutter/material.dart';
import 'package:milyar/pages/Auth/Type_Register_Screen.dart';
import 'package:milyar/pages/bottomNavigationBar.dart/BottomNavigationApp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String jwt;
  _getFromCach() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      jwt = preferences.getString('jwt');

      print(preferences.getString('id'));
    });
  }

  @override
  void initState() {
    _getFromCach();
    Timer(Duration(seconds: 2), () async {
      if (jwt != null) {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomPageBar()));
      } else {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => TypeRegisterScreen()));
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => TypeRegisterScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue[400],
        child: Center(
          child: Image(
            width: 100,
            height: 100,
            color: Colors.white,
            image: AssetImage("assets/whtitelogo.png"),
          ),
        ),
      ),
    );
  }
}
