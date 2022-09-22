import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/main_page.dart';
import 'package:login/screens/profile.dart';
import 'package:login/screens/splash.dart';
import 'package:http/http.dart' as http;
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MoreScreenState();
  }
}

class MoreScreenState extends State<MoreScreen> {
  String name ="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                          ),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      '$name',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2596be)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "4 Orders",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            color: Colors.grey.withOpacity(0.8),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                ProfilePage()));
                      },
                      child: Text(
                        "Profile",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF2596be)),
                      )),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text("Orders",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF2596be)))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xFF2596be),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: TextButton(
                          onPressed: () {
                            IsLogedOut();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Splash()));
                          },
                          child: Text("Logout",
                              style: TextStyle(color: Colors.white)))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  IsLogedOut() async {
    final prefs = await SharedPreferences.getInstance();
    final Id = await prefs.remove(ConstantValue.ID);
    final Email = await prefs.remove(ConstantValue.Email);
    final Name = await prefs.remove(ConstantValue.Name);
    final Phone = await prefs.remove(ConstantValue.Phone);

    if (Email == "" && Id == "" && Name == "" && Phone == "") {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Splash())));
    }
  }

  Future GetUser() async {
    final prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString(ConstantValue.Name) ?? "";


      setState(() {
        name = userName;
      });

  }
}
