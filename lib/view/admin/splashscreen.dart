import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/authMemory.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  loggedIn() {
    Timer(Duration(seconds: 3), () async {
      if (await AuthMemory().loggedIn() != true) {
        Navigator.pushReplacementNamed(context, '/allScreens');
      } else {
        Navigator.pushReplacementNamed(context, '/beforeLogin');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.png',
      width: 210,
      height: 210,),),
    );
  }
}
