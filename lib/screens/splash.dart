import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login/screens/login.dart';
import 'package:login/screens/main_page.dart';
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends  StatefulWidget {
  State<StatefulWidget> createState() {
    return  SplashState();
  }
}

class SplashState extends State<Splash>{
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body:Center(
        child: (Image.asset(
          "images/login.png",
          width: 250,
          height: 250,
        ))),
  );
  }

  @override
  void initState() {
    super.initState();
    checkUserIsLogin();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Login())));
  }

  checkUserIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID)?? "";
    if(userId == ""){
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Login())));

    }else{
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>MainScreen())));
    }
  }
}

